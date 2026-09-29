{
  stdenvNoCC,
  fetchurl,
  lib,
}:
# mo (https://github.com/k1LoW/mo) — Markdown ビューア。
#
# nixpkgs には収録されているが、名前が異なるうえ pinned nixpkgs (nixos-26.05) には
# 未収録:
#   - nixpkgs の `mo`            = tests-always-included/mo (Bash 向け Mustache テンプレート) — 別ツール
#   - nixpkgs の `mo-viewer`     = k1LoW/mo 本体だが nixos-unstable 以降のみ
# upstream に flake.nix は無いため、公式リリースのバイナリをそのまま導入する。
#
# version / hash は .github/workflows/update-mo.yml が毎週更新 PR を作る。
# 手動で更新する場合:
#   nix-prefetch-url https://github.com/k1LoW/mo/releases/download/v<version>/mo_v<version>_linux_amd64.tar.gz
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mo";
  version = "1.6.9";

  src = fetchurl {
    url = "https://github.com/k1LoW/mo/releases/download/v${finalAttrs.version}/mo_v${finalAttrs.version}_linux_amd64.tar.gz";
    sha256 = "0q89r9v7hsff1as5dxp77309s33qlpjmlcxvvbp4vsbvriipk6nn";
  };

  sourceRoot = ".";
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall
    install -Dm755 mo $out/bin/mo
    runHook postInstall
  '';

  meta = {
    description = "Markdown viewer that opens .md files in a browser";
    homepage = "https://github.com/k1LoW/mo";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "mo";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
