# hermes-agent の upstream パッケージングバグに対するローカル回避策。
#
# NousResearch/hermes-agent は wheel に含めるトップレベルモジュールを
# pyproject.toml の [tool.setuptools] py-modules で列挙している。2026-09-03 の
# rev 7b72fd1 以降 hermes_state.py が hermes_state_holders と
# hermes_state_registry を import するようになったが、両モジュールとも
# py-modules への追加が漏れており wheel に同梱されない。結果として
# `import hermes_state` が ModuleNotFoundError で失敗し、セッション DB を触る
# 経路（hermes sessions / dashboard / hermes-desktop の起動）が全滅する。
#
# 回避策として、ソースツリーから漏れているモジュールだけを取り出した Python
# パッケージを作り、upstream が用意している extraPythonPackages 拡張点経由で
# hermes ラッパーの PYTHONPATH に足す。
#
# upstream の py-modules に両モジュールが追加されたらこのファイルを削除し、
# packages-common.nix / packages.nix を素の
# hermes-agent.packages.<system>.{default,desktop} に戻す。
{ pkgs, hermes-agent }:
let
  system = pkgs.stdenv.hostPlatform.system;

  # shim は hermes-agent 自身の nixpkgs の python312 でビルドする必要がある。
  # hermes-agent.nix が使う requiredPythonModules は pythonModule が同一の
  # python を指すパッケージだけを残すため、こちらの nixpkgs (nixos-26.05) の
  # python312 で作ると、エラーにならず黙って PYTHONPATH から脱落する。
  hermesPkgs = hermes-agent.inputs.nixpkgs.legacyPackages.${system};

  upstream = hermes-agent.packages.${system}.default;

  # wheel から漏れているトップレベルモジュール。
  missingTopLevelModules = [
    "hermes_state_holders"
    "hermes_state_registry"
  ];

  missingModulesShim = hermesPkgs.python312.pkgs.buildPythonPackage {
    pname = "hermes-missing-top-level-modules";
    inherit (upstream) version;
    format = "other";
    # flake input のソースツリー。wheel ではなく生の .py を直接拾う。
    src = hermes-agent;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p "$out/${hermesPkgs.python312.sitePackages}"
      ${pkgs.lib.concatMapStringsSep "\n" (module: ''
        cp "${module}.py" "$out/${hermesPkgs.python312.sitePackages}/"
      '') missingTopLevelModules}
      runHook postInstall
    '';
  };

  # hermesDesktop は passthru で finalPackage を参照するため、override した
  # 側の hermes を HERMES_DESKTOP_HERMES に埋め込んでくれる。
  patched = upstream.override {
    extraPythonPackages = [ missingModulesShim ];
  };
in
{
  cli = patched;
  desktop = patched.hermesDesktop;
}
