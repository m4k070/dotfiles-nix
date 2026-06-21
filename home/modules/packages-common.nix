{ pkgs, lib, claude-code, hibiki, ... }:
let
  dotnet-combined = with pkgs.dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_10_0
  ];
in {
  home.packages = with pkgs; [
    bat
    bitwarden-cli
    btop
    claude-code.packages.${pkgs.system}.default
    #hibiki.packages.${pkgs.system}.default
    cmake
    curl
    dig
    dotnet-combined
    fd
    gcc
    (lib.lowPrio gdb)
    ghq
    github-copilot-cli
    gnumake
    go-task
    jq
    lazygit
    mise
    nb
    opencode
    platformio
    postgresql
    rclone
    ripgrep
    rtk
    sd
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
}
