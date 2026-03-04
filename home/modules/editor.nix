{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  programs.zellij = {
    enable = true;
    extraConfig = ''
show_startup_tips false
theme "kanagawa"
plugins {
    tab-bar { path "tab-bar"; }
    status-bar { path "status-bar"; }
    strider { path "strider"; }        // ファイルマネージャー
    compact-bar { path "compact-bar"; } // コンパクトなステータスバー
}
    '';
  };

  xdg.configFile."nvim" = {
    source = ../../configs/neovim;
    recursive = true;
  };
}
