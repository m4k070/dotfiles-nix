{ config, pkgs, claude-code, hibiki, lib, ... }:
let
  inherit (import ./options.nix) username;
  dotnet-combined = with pkgs.dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_10_0
  ];
in {
  imports = [
    ./modules/shell.nix
    ./modules/git.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
  news.display = "silent";

  home.packages = with pkgs; [
    bat
    bitwarden-cli
    btop
    claude-code.packages.${pkgs.system}.default
    hibiki.packages.${pkgs.system}.default
    babashka
    clingo
    cmake
    curl
    dig
    dotnet-combined
    eza
    fd
    fzf
    gcc
    gdb
    gemini-cli
    gh
    ghq
    git
    github-copilot-cli
    gnumake
    go-task
    jq
    lazygit
    mise
    nb
    poppler-utils
    postgresql
    python314
    rclone
    ripgrep
    sd
    starship
    uv
    whois
    yazi
    yq
    zig
    # Language Servers
    clojure-lsp
    fsautocomplete
    gopls
    lua-language-server
    marksman
    postgres-language-server
    rust-analyzer
    svelte-language-server
    typescript-language-server
    yaml-language-server
    # vim plugins
    vimPlugins.Ionide-vim
    vimPlugins.nvim-treesitter-parsers.clojure
    vimPlugins.nvim-treesitter-parsers.css
    vimPlugins.nvim-treesitter-parsers.fsharp
    vimPlugins.nvim-treesitter-parsers.go
    vimPlugins.nvim-treesitter-parsers.html
    vimPlugins.nvim-treesitter-parsers.json
    vimPlugins.nvim-treesitter-parsers.lua
    vimPlugins.nvim-treesitter-parsers.typescript
    skkDictionaries.emoji
  ];

  home.sessionPath = [
    "~/go/bin"
  ];

  # neovimとzellijのみ（VSCodeはGUI環境が必要）
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
    strider { path "strider"; }
    compact-bar { path "compact-bar"; }
}
    '';
  };

  programs.starship.enable = true;

  xdg.enable = true;
  xdg.configFile."nvim" = {
    source = ../configs/neovim;
    recursive = true;
  };
  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;

  programs.git.settings.user.email = lib.mkForce "makoto.ito@tsukasa-ind.co.jp";

  programs.go = {
    enable = true;
    env = {
      GOPATH = [
        "${config.home.homeDirectory}/go"
      ];
      GOPRIVATE = [
        "github.com/tsukasa-ind/"
      ];
    };
  };
}
