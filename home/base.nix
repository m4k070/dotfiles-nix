{config, pkgs, nixgl, noctalia, ...}:
let
  inherit (import ./options.nix) username;
in {
  imports = [
    noctalia.homeModules.default
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    packages = with pkgs; [
      bat
      bitwarden-desktop
      blender
      btop 
      curl
      dbeaver-bin
      eza
      firefox
      gimp
      git
      jq
      logseq
      mise
      openssh
      rclone
      ripgrep
      starship
      udev-gothic
      # vivaldi
      # vivaldi-ffmpeg-codecs
      xwayland-satellite
      yq
      zig
      # Language Servers
      clojure-lsp
      gopls
      marksman
      postgres-language-server
      rust-analyzer
      svelte-language-server
      typescript-language-server
      yaml-language-server
      # vim plugins
      vimPlugins.nvim-treesitter-parsers.go
      vimPlugins.nvim-treesitter-parsers.typescript
      vimPlugins.nvim-treesitter-parsers.json
      vimPlugins.nvim-treesitter-parsers.clojure
    ];
  };

  services = {
    gnome-keyring.enable = true;
  };

  xdg.enable = true;
  xdg.mime.enable = true;

  programs.home-manager.enable = true;
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };
  programs.vivaldi = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-wayland-ime"
    ];
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.zsh = {
    enable = true;
    autocd = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "bat";
      less = "bat --pager=less";
      ls = "eza --icons";
      vi = "nvim";
      vim = "nvim";
    };
    history.size = 10000;
    history.ignoreAllDups = true;
  };
  programs.git = {
    enable = true;
    settings.user.name = "Makoto Ito";
    settings.user.email = "m4k070@pm.me";
  };
  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-markdown-preview];
  };
  programs.starship = {
    enable = true;
  };
  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;

  xdg.configFile."nvim" = {
    source = ../configs/neovim;
    recursive = true;
  };

  news.display = "silent";
}
