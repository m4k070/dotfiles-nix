{ pkgs, hermes-agent, ... }:
let
  # Orca (https://github.com/stablyai/orca) は複数AIコーディングエージェントを
  # 並列実行するElectron製IDE。nixpkgs未収録のためAppImageをラップして導入する。
  # version/sha256 は .github/workflows/update-orca.yml が毎週更新 PR を作る。
  # 手動で更新する場合:
  # nix-prefetch-url https://github.com/stablyai/orca/releases/download/v<version>/orca-linux.AppImage
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
  # mo (https://github.com/k1LoW/mo) — Markdown ビューア。nixpkgs の `mo` は同名の別ツール
  # (tests-always-included/mo)、k1LoW/mo は `mo-viewer` として unstable 以降にのみ収録。
  # pinned nixpkgs (nixos-26.05) では解決できないため home/pkgs/mo でパッケージングする。
  # version/sha256 は .github/workflows/update-mo.yml が毎週更新 PR を作る。
  mo = pkgs.callPackage ../pkgs/mo { };
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
    drawio
    ffmpeg-headless
    ffmpegthumbnailer
    firefox
    fuzzel
    gimp
    mo
    nautilus
    networkmanagerapplet
    niri
    nwg-look
    obsidian
    orca-ide
    pavucontrol
    qimgv
    udev-gothic
    vial
    vivaldi-ffmpeg-codecs
    wl-clipboard
    xwayland-satellite
    # Hermes Agent (デスクトップGUI。CLI本体はpackages-common.nixで共通インストール)
    hermes-agent.packages.${pkgs.stdenv.hostPlatform.system}.desktop
  ];
}
