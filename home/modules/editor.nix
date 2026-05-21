{ pkgs, ... }: {
  imports = [
    ./editor-common.nix
  ];

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };
}
