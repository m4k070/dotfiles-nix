{ pkgs, ... }: {
  imports = [
    ./packages-common.nix
  ];

  # デスクトップ専用パッケージ
  home.packages = with pkgs; [
    bitwarden-desktop
    blender
    dbeaver-bin
    ffmpeg-headless
    ffmpegthumbnailer
    firefox
    fuzzel
    gimp
    microsoft-edge
    nautilus
    networkmanagerapplet
    niri
    nwg-look
    obsidian
    pavucontrol
    platformio
    udev-gothic
    vivaldi-ffmpeg-codecs
    wl-clipboard
    xwayland-satellite
  ];
}
