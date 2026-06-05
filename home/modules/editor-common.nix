{ pkgs, lib, ... }: {
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

  # Doom Emacs
  programs.emacs = {
    enable = true;
    # pgtk ビルド: Wayland (niri) ネイティブ対応
    package = pkgs.emacs-pgtk;
    # ネイティブモジュールが必要なパッケージをnixでビルド済みにする
    # → Doom起動時のコンパイルが不要になる
    extraPackages = epkgs: [ epkgs.vterm ];
  };

  # Doom 設定ファイルを ~/.config/doom/ に配置
  xdg.configFile."doom" = {
    source = ../../configs/doom;
    recursive = true;
  };

  # Emacs 29+ treesit grammars: TypeScript/JavaScript用
  # Doom :lang (javascript +tree-sitter) が typescript-ts-mode を使うために必要
  # linkFarm が lib/libtree-sitter-<lang>.so を作成し、emacs/tree-sitter/ からロードされる
  xdg.configFile."emacs/tree-sitter" = {
    source = "${pkgs.emacs-pgtk.pkgs.treesit-grammars.with-grammars (g: with g; [
      tree-sitter-javascript
      tree-sitter-jsdoc
      tree-sitter-tsx
      tree-sitter-typescript
    ])}/lib";
  };

  # Doom Emacs 本体の初回セットアップ案内
  # activation スクリプトでの git clone はsystemd制限環境でSSHが使えないため手動で実行する
  home.activation.installDoom = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    DOOM_DIR="$HOME/.config/emacs"
    if [ ! -d "$DOOM_DIR/.git" ]; then
      echo ""
      echo ">>> Doom Emacs が未インストールです。以下を手動で実行してください:"
      echo ">>>   git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs"
      echo ">>>   ~/.config/emacs/bin/doom install"
      echo ">>>   ~/.config/emacs/bin/doom sync"
      echo ""
    fi
  '';
}
