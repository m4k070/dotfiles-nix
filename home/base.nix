{config, pkgs, nixgl, lib, ...}:
let
  inherit (import ./options.nix) username;
in {
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
      nb
      openssh
      rclone
      ripgrep
      starship
      udev-gothic
      # vivaldi
      vivaldi-ffmpeg-codecs
      xwayland-satellite
      yazi
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
      # QT/KDE
      kdePackages.qt6ct
      libsForQt5.qt5ct
      kdePackages.qtwayland
      kdePackages.qtstyleplugin-kvantum
      # kdePackages.breeze-icons
    ];
  };

  services = {
    gnome-keyring.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };

  xdg.enable = true;
  xdg.mime.enable = true;

  programs.home-manager.enable = true;

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
    initContent = lib.mkAfter "eval \"$(mise activate zsh)\"";
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
