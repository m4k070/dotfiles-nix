{config, pkgs, nixgl, lib, noctalia, ...}:
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
      dotnet-sdk_10
      eza
      firefox
      fzf
      gimp
      gh
      git
      jq
      logseq
      mise
      nb
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
    ];
  };

  services = {
    gnome-keyring.enable = true;
    udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };
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
  };

  xdg.enable = true;
  xdg.mime.enable = true;

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
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
    initContent = lib.mkAfter ''
      eval "$(mise activate zsh)"
      export PATH="$HOME/go/bin:$PATH"
    '';
  };

  programs.gh = {
    enable = true;
    extensions = with pkgs; [gh-markdown-preview];
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;
    settings.user.name = "Makoto Ito";
    settings.user.email = lib.mkDefault "m4k070@pm.me";
  };

  programs.starship = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    mouse = true;
    keyMode = "vi";
    escapeTime = 0;
    clock24 = true;
    terminal = "screen-256color";
    extraConfig = ''
      # window移動
      bind -n M-l next-window
      bind -n M-h previous-window
      
      bind -n M-j switch-client -n
      bind -n M-k switch-client -p
      
      # pane移動
      bind -n C-h select-pane -L
      bind -n C-j select-pane -D
      bind -n C-k select-pane -U
      bind -n C-l select-pane -R
      
      # TERMを設定
      set -g terminal-overrides 'xterm:colors=256'
      
      # スクロールアップするとコピーモードに入る
      bind-key -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'select-pane -t=; copy-mode -e; send-keys -M'"
      
      # 最後までスクロールダウンするとコピーモードを抜ける
      bind-key -n WheelDownPane select-pane -t= \; send-keys -M
      
      # リロード
      bind r source-file ~/.tmux.conf
    '';
  };

  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;

  xdg.configFile."nvim" = {
    source = ../configs/neovim;
    recursive = true;
  };

  xdg.configFile."yazi/theme.toml".source = ../configs/yazi/theme.toml;
  
  news.display = "silent";
}
