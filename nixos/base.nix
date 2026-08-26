# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  # YubiKey 挿入時に、ロック中の本人のグラフィカルセッションだけを
  # 専用 PAM サービスで認証して解除する。認証失敗はサービス自体の失敗にしない。
  # サービスが failed になると、抜去時の ExecStop（ロック）が保証できないため。
  yubikeyUnlock = pkgs.writeShellScript "yubikey-unlock" ''
    target_session=""

    while read -r session uid _; do
      [ "$uid" = "$UID" ] || continue
      [ "$(${pkgs.systemd}/bin/loginctl show-session "$session" -p Class --value)" = "user" ] || continue
      case "$(${pkgs.systemd}/bin/loginctl show-session "$session" -p Type --value)" in
        wayland|x11) ;;
        *) continue ;;
      esac
      [ "$(${pkgs.systemd}/bin/loginctl show-session "$session" -p LockedHint --value)" = "yes" ] || continue
      target_session="$session"
      break
    done < <(${pkgs.systemd}/bin/loginctl list-sessions --no-legend)

    # 挿入時にロックされていなければ、何もしない。
    if [ -z "$target_session" ]; then
      echo "unlock skipped: no locked graphical session"
      exit 0
    fi

    # U2F 署名とユーザープレゼンス（タッチ）のみを受け付ける。
    # 15秒以内に認証できた場合だけ、選択済みのセッションを解除する。
    if ${pkgs.coreutils}/bin/timeout --foreground 15s \
      ${pkgs.pamtester}/bin/pamtester yubikey-unlock "$USER" authenticate; then
      # 認証中に別経路で解除された場合は二重に解除要求しない。
      if [ "$(${pkgs.systemd}/bin/loginctl show-session "$target_session" -p LockedHint --value)" = "yes" ]; then
        ${pkgs.systemd}/bin/loginctl unlock-session "$target_session"
        echo "unlock succeeded: session=$target_session authentication=u2f"
      else
        echo "unlock skipped: session=$target_session already unlocked"
      fi
    else
      echo "unlock denied or timed out: session=$target_session authentication=u2f" >&2
    fi

    exit 0
  '';
in
{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  #time.hardwareClockInLocalTime = true;

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ja_JP.UTF-8";
    LC_IDENTIFICATION = "ja_JP.UTF-8";
    LC_MEASUREMENT = "ja_JP.UTF-8";
    LC_MONETARY = "ja_JP.UTF-8";
    LC_NAME = "ja_JP.UTF-8";
    LC_NUMERIC = "ja_JP.UTF-8";
    LC_PAPER = "ja_JP.UTF-8";
    LC_TELEPHONE = "ja_JP.UTF-8";
    LC_TIME = "ja_JP.UTF-8";
  };

  # GNOMEがデフォルトでIBusを設定するため、システムレベルでfcitx5を明示して上書きする
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-skk
    ];
  };
 
  fonts = {
    packages = with pkgs; [
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.noto
      nerd-fonts.jetbrains-mono
      migu
      udev-gothic
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = ["Noto Serif CJK JP" "Noto Color Emoji"];
        sansSerif = ["Noto Sans CJK JP" "Noto Color Emoji"];
        monospace = ["UDEV Gothic" "JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };
  };

  # Enable Desktop Environment.
  #services.gnome.gnome-keyring.enable = true;
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  #environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];
  security.pam.services.greetd.enableGnomeKeyring = true;

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
    # 自動解除専用。デフォルト規則を使わず、パスワードへのフォールバックを持たせない。
    # Noctalia の手動解除は引き続き login PAM（U2F またはパスワード）を使う。
    yubikey-unlock.text = ''
      auth required ${pkgs.pam_u2f}/lib/security/pam_u2f.so cue
    '';
  };
  services.udev.extraRules = ''
      SUBSYSTEM=="usb",ATTRS{idProduct}=="0407",ATTRS{idVendor}=="1050",TAG+="systemd",ENV{SYSTEMD_ALIAS}="/sys/subsystem/usb/devices/yubikey"
      SUBSYSTEM=="input",ATTRS{idVendor}=="4653",ATTRS{idProduct}=="0004",ENV{ID_INPUT_JOYSTICK}="0"
      KERNEL=="hidraw*",ATTRS{idVendor}=="4653",ATTRS{idProduct}=="0004",MODE="0664",GROUP="users"
      SUBSYSTEM=="usb",ATTRS{idVendor}=="18d1",ATTRS{idProduct}=="4ee0",TAG+="uaccess"
  '';
  # YubiKey を挿してタッチすると解除し、抜いた瞬間に Wayland セッションをロックする。
  # 仕組み: BindsTo で YubiKey の .device ユニットに束縛し、RemainAfterExit で
  # デバイスが挿さっている間ユニットを active に保つ。ExecStart は専用 PAM で解除を試み、
  # デバイスが消えると systemd がユニットを停止して ExecStop が発火する。
  # ロックは polkit 対話認証を要求する `loginctl lock-sessions` ではなく、
  # このマシンの実ロッカーである noctalia を直接叩く（niri キーバインドと同一経路）。
  systemd.user.services.yubikey-connect-service = {
    enable = true;
    description = "Unlock on YubiKey touch and lock when it is removed";
    bindsTo = [ "sys-subsystem-usb-devices-yubikey.device" ];
    wantedBy = [ "sys-subsystem-usb-devices-yubikey.device" ];
    serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = yubikeyUnlock;
        ExecStop = "/etc/profiles/per-user/makoto/bin/noctalia msg session lock";
    };
  };

  # NTP
  services.chrony = {
    enable = true;
    servers = ["ntp.nict.jp"];
  };

  # removal disk
  services.udisks2.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  
  xdg.portal.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.makoto = {
    isNormalUser = true;
    description = "makoto";
    extraGroups = [ "networkmanager" "wheel" "docker" "scanner" "lp" "dialout" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  #programs.firefox.enable = true;

  programs.nix-ld.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.seahorse.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gdk-pixbuf   # システム全体の GDK pixbuf ローダー（GTK サムネイル等）
    libheif      # HEIF/HEIC コーデック（システム全体のファイルタイプ処理）
    libheif.out
    openssl_3
    usbutils
  ];

  nixpkgs.config.allowUnfree = true;
  # EOL パッケージを一時的に許可（upstream の更新待ち）
  # - electron-39.8.10: obsidian が依存
  # - pypy2.7-setuptools-44.0.0: sunshine → resholve が依存
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "pypy2.7-setuptools-44.0.0"
    "pypy2.7-pip-20.3.4"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services.tailscale.enable = true;
  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "docker0" "tailscale0" ];
    allowedTCPPorts = [ 3456 8765 8766 ];
    allowedUDPPorts = [config.services.tailscale.port];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  virtualisation.docker = {
    enable = true;
    # daemon.settings.pruning = {
    #   enabled = true;
    #   interval = "24h";
    # };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

  nix = {
    settings = {
      download-buffer-size = 524288000;
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
      extra-substituters = [ "https://cache.nixos-cuda.org" "https://noctalia.cachix.org" ];
      extra-trusted-public-keys = [ "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
