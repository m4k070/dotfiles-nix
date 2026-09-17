# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:
{
  imports =
    [
      ../../nixos/base.nix
      ../../nixos/gnome.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.overlays = [
    (import ../../katrain-nix/katrain-overlay.nix)
    (final: prev: {
      # nixpkgs-unstable バグ回避: writers/scripts.nix の makePythonWriter が
      # `pythonPackages != pkgs.pypy2Packages || pythonPackages != pkgs.pypy3Packages` を
      # 評価する際に pypy2/pypy3 パッケージが強制評価されるが、pypy は i686-linux 非対応。
      # 32bit コンテキストで pypy 系パッケージをスタブ化することで評価エラーを防ぐ。
      pkgsi686Linux = prev.pkgsi686Linux.extend (_: _: {
        pypy2 = builtins.throw "pypy2 is not available on i686-linux";
        pypy3 = builtins.throw "pypy3 is not available on i686-linux";
        pypy = builtins.throw "pypy is not available on i686-linux";
        pypy2Packages = { };
        pypy3Packages = { };
      });
    })
  ];

  networking.hostName = "vega"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    sunshine
  ];

  # Linux 7.2 で strncpy がカーネルから削除されたため、nixos-26.05 の nvidia
  # ドライバ (production = 595.71.05) は os-interface.c で implicit declaration
  # エラーになりビルドできない。open modules でも同じ。
  # 従来使っていた 7.1 / 7.0 は EOL で nixpkgs から削除済みのため、LTS の 6.18 を使う。
  #
  # 7.2 に上げたい場合は nvidia 595.99.02 以上が必要（proprietary / open とも
  # 7.2.4 でビルド成功を確認済み）。ただし 595.99.02 は nixos-unstable のみで
  # nixos-26.05 には未到達。26.05 が追いついたら 7.2 + latest ドライバに戻せる。
  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;

  # WiFi (MT7921K / mt7921e) の接続安定化。kernel 6.18.50 → 6.18.52 を入れた
  # 2026-09-18 以降、メッシュ AP 間のローミングで認証が失敗し DHCPv4 が確立しなく
  # なった。ログから読み取れた要因は 2 つ:
  #
  # 1. 規制ドメインが固定されておらず、切断のたびに CORE/WORLD (00) へ戻り、AP の
  #    COUNTRY_IE で JP に復帰するまで 5GHz W53/W56 が passive scan のみになる。
  #    その間に DFS ch (116) の AP が CSA 中だと
  #    "AP is in CSA process, reject auth" となり、最も電波の良い BSSID が
  #    wpa_supplicant の ignore list に入って選ばれなくなる。
  #    → cfg80211 の初期 regdomain を JP に固定し、WORLD フォールバックをなくす。
  #      (regulatory.db 自体は hardware.wirelessRegulatoryDatabase = true で既に有効)
  #
  # 2. 省電力 (PSM) 有効下で
  #    "deauthenticating ... by local choice (Reason: 2=PREV_AUTH_NOT_VALID)"
  #    が頻発する。mt7921e では既知の不安定要因。
  #    → NetworkManager 側で WiFi powersave を明示的に無効化する
  #      (既定の null は NM のデフォルト = 有効側に委ねる意味になるため明示する)。
  #
  # なお不調が 6.18.52 固有の回帰かどうかは generation 281 (6.18.50) で起動して
  # 切り分ける。回帰であれば上記に加えてカーネルの点リリース固定を検討する。
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom=JP
  '';
  networking.networkmanager.wifi.powersave = false;

  programs.kdeconnect = {
    enable = true;
  };

  programs.hyprland.enable = true;
  programs.niri.enable = true;
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 256;
      "default.clock.min-quantum" = 128;
      "default.clock.max-quantum" = 1024;
    };
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia-container-toolkit.enable = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ]; # Helpful for network scanners
  services.udev.packages = [ pkgs.brscan5 ];

  # Waydroid (Android コンテナ)
  # モジュール側で lxc / binder / dbus / firewall(waydroid0) の設定は自動的に行われる。
  # 初回のみ `sudo waydroid init` でシステムイメージの取得が必要。
  # nftables ベースのネットワーク設定を使用（カーネルに ip_tables モジュールがないため）
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
