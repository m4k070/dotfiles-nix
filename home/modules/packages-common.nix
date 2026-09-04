{ pkgs, lib, claude-code, hibiki, herdr, omp-flake, hermes-agent, ... }:
let
  # upstream の wheel からモジュールが漏れているため、パッチ版を使う。詳細は
  # ../pkgs/hermes-agent.nix のコメントを参照。
  hermesAgent = import ../pkgs/hermes-agent.nix { inherit pkgs hermes-agent; };

  dotnet-combined = with pkgs.dotnetCorePackages; combinePackages [
    sdk_8_0
    sdk_10_0
  ];
in {
  imports = [
    omp-flake.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    bat
    bitwarden-cli
    btop
    claude-code.packages.${pkgs.stdenv.hostPlatform.system}.default
    herdr.packages.${pkgs.stdenv.hostPlatform.system}.default
    #hibiki.packages.${pkgs.stdenv.hostPlatform.system}.default
    cmake
    curl
    dig
    dotnet-combined
    fd
    gcc
    (lib.lowPrio gdb)
    ghq
    gnumake
    go-task
    jq
    lazygit
    mermaid-cli
    mermaid-filter
    mise
    nb
    opencode
    pandoc
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
    # Hermes Agent (CLI/TUI本体、ヘッドレス環境でも利用)
    hermesAgent.cli
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
