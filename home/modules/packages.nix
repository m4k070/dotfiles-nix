{ pkgs, ... }: {
  imports = [
    ./packages-common.nix
  ];

  # デスクトップ専用パッケージ
  home.packages = with pkgs; [
    bitwarden-desktop
    blender
    dbeaver-bin
    firefox
    fuzzel
    gimp
    microsoft-edge
    niri
    obsidian
    udev-gothic
    vivaldi-ffmpeg-codecs
    xwayland-satellite
  ];
}
