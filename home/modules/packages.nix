{ pkgs, hermes-agent, ... }:
let
  # upstream の wheel からモジュールが漏れているため、パッチ版を使う。詳細は
  # ../pkgs/hermes-agent.nix のコメントを参照。
  hermesAgent = import ../pkgs/hermes-agent.nix { inherit pkgs hermes-agent; };
in {
  imports = [
    ./packages-common.nix
  ];

  # デスクトップ専用パッケージ
  home.packages = with pkgs; [
    _1password-cli
    art
    blender
    dbeaver-bin
    ffmpeg-headless
    ffmpegthumbnailer
    firefox
    fuzzel
    gimp
    nautilus
    networkmanagerapplet
    niri
    nwg-look
    obsidian
    pavucontrol
    udev-gothic
    vial
    vivaldi-ffmpeg-codecs
    wl-clipboard
    xwayland-satellite
    # Hermes Agent (デスクトップGUI。CLI本体はpackages-common.nixで共通インストール)
    hermesAgent.desktop
  ];
}
