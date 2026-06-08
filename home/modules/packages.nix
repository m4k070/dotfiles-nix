{ pkgs, ... }: {
  imports = [
    ./packages-common.nix
  ];

  # デスクトップ専用パッケージ
  home.packages = with pkgs; [
    _1password-cli
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
    udev-gothic
    vivaldi-ffmpeg-codecs
    wl-clipboard
    xwayland-satellite
  ];
}
