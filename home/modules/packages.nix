{ pkgs, hermes-agent, ... }: {
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
    hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  ];
}
