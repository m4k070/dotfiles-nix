{config, pkgs, nixgl, lib, noctalia, nix-hazkey, ...}:
let
  inherit (import ./options.nix) username;
in {
  imports = [
    noctalia.homeModules.default
    nix-hazkey.homeModules.hazkey
  ];

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";

    sessionVariables = {
      "QT_QPA_PLATFORMTHEME" = "gtk3";
      "SSH_AUTH_SOCK" = "$HOME/.bitwarden-ssh-agent.sock";
      "NIXOS_OZONE_WL" = "1";
    };

    packages = with pkgs; [
      bat
      bitwarden-cli
      bitwarden-desktop
      blender
      btop 
      claude-code
      cmake
      curl
      dbeaver-bin
      dotnet-sdk_10
      eza
      firefox
      fuzzel
      fzf
      gcc
      gdb
      gemini-cli
      gh
      gimp
      github-copilot-cli
      git
      git-wt
      gnumake
      go-task
      jq
      jujutsu
      logseq
      mise
      nb
      niri
      rclone
      ripgrep
      starship
      thorium-reader
      udev-gothic
      uv
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

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.catppuccin-cursors.latteDark;
      name = "catppuccin-latte-dark-cursors";
      size = 24;
    };
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
  };

  services = {
    hazkey.enable = true;

    gnome-keyring.enable = true;

    udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };

    kanshi = {
      enable = true;
      settings = [
        {
          output.criteria = "AU Optronics 0xFA9B Unknown";
          output.scale = 1.25;
          output.mode = "1920x1200@60.026";
          output.alias = "INTERNAL";
        }
        {
          # output.criteria = "Iiyama North America PL2492H 1225743345887";
          output.criteria = "Iiyama North America PL2492H 1225743345900";
          output.scale = 1.0;
          output.mode = "1920x1080@100.000";
          output.alias = "OFFICE";
        }
        {
          output.criteria = "ASUSTek COMPUTER INC PA278QV MALMQS119530";
          output.scale = 1.0;
          output.mode = "2560x1440@59.951";
          output.alias = "HOME";
        }
        {
          output.criteria = "HP Inc. HP Z24n G2 6CM9490RTY";
          output.scale = 1.0;
          output.mode = "1920x1200@59.950";
          output.alias = "OFFICE2";
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "$INTERNAL";
              position = "1920,0";
            }
            {
              criteria = "$OFFICE";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "office2";
          profile.outputs = [
            {
              criteria = "$INTERNAL";
              position = "1920,0";
            }
            {
              criteria = "$OFFICE2";
              position = "0,0";
            }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            {
              criteria = "$HOME";
            } 
          ];
        }
      ];
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

  programs.fzf = {
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

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
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
    dotDir = "${config.xdg.configHome}/zsh";
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      cat = "bat";
      cd = "z";
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

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.sheldon = {
    enable = true;
    enableZshIntegration = true;
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

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      asvetliakov.vscode-neovim
      vscodevim.vim
      yzhang.markdown-all-in-one
    ];
  };

  xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;

  xdg.userDirs = {
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
  };

  xdg.configFile."nvim" = {
    source = ../configs/neovim;
    recursive = true;
  };

  xdg.configFile."yazi/theme.toml".source = ../configs/yazi/theme.toml;
  
  news.display = "silent";
}
