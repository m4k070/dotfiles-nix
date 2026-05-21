{ pkgs, ... }: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    withRuby = false;
    withPython3 = false;
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
