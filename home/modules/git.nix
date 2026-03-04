{ pkgs, lib, ... }: {
  programs.git = {
    enable = true;
    settings.user.name = "Makoto Ito";
    # プロファイルごとにオーバーライド可能なデフォルト値
    settings.user.email = lib.mkDefault "m4k070@pm.me";
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [ gh-markdown-preview ];
    gitCredentialHelper.enable = true;
  };
}
