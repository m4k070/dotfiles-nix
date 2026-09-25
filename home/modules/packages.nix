{ pkgs, hermes-agent, ... }:
let
  # Orca (https://github.com/stablyai/orca) は複数AIコーディングエージェントを
  # 並列実行するElectron製IDE。nixpkgs未収録のためAppImageをラップして導入する。
  # リリース頻度が高いため、更新時は version/hash を再取得すること
  # (nix-prefetch-url https://github.com/stablyai/orca/releases/download/v<version>/orca-linux.AppImage)
  orca-ide =
    let
      pname = "orca-ide";
      version = "1.4.199";
      src = pkgs.fetchurl {
        url = "https://github.com/stablyai/orca/releases/download/v${version}/orca-linux.AppImage";
        sha256 = "0idgxdhxc1app4jqbx4f767yb24gjyhxnkhmkjdbf5f81m1gvcdf";
      };
      appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -Dm444 ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
        install -Dm444 ${appimageContents}/${pname}.png $out/share/pixmaps/${pname}.png
        substituteInPlace $out/share/applications/${pname}.desktop \
          --replace-fail 'Exec=AppRun %U' 'Exec=${pname} %U'
      '';
      meta = {
        description = "AI orchestrator IDE for running multiple coding agents in parallel";
        homepage = "https://github.com/stablyai/orca";
        platforms = [ "x86_64-linux" ];
        mainProgram = pname;
      };
    };
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
    orca-ide
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
