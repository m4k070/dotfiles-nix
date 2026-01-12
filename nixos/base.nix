# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

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

  # i18n.inputMethod = {
  #   enable = true;
  #   type = "fcitx5";
  #   fcitx5.waylandFrontend = true;
  # };
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
 
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
  services.gnome.gnome-keyring.enable = true;
  services.displayManager.gdm.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  security.pam.u2f = {
    enable = true;
    settings.cue = true;
  };
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };
  services.udev.extraRules = ''
      ACTION=="remove",\
      ENV{ID_MODEL_ID}=="0407",\
      ENV{ID_VENDOR_ID}=="1050",\
      RUN+="${pkgs.systemd}/bin/loginctl lock-sessions"
      ATTRS{idVendor}=="4653",ATTRS{idModel}=="0004",ENV{ID_INPUT_JOYSTICK}=""
  '';

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
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  #programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
  };

  programs.niri = {
    enable = true;
  };

  programs.seahorse.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    #mako
    ffmpeg-headless
    ffmpegthumbnailer
    gdk-pixbuf
    gh
    git
    kanagawa-gtk-theme
    kanagawa-icon-theme
    libheif
    libheif.out
    nautilus
    networkmanagerapplet
    nwg-look
    openssh
    papirus-icon-theme
  ];

  nixpkgs.config.allowUnfree = true;

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
    trustedInterfaces = ["tailscale0"];
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
      auto-optimise-store = true;
      experimental-features = ["nix-command" "flakes"];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
