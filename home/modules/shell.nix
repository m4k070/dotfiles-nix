{ config, pkgs, lib, ... }: {
  home.sessionVariables = {
    # "QT_QPA_PLATFORMTHEME" = "gtk3";
    # "SSH_AUTH_SOCK" = "$HOME/.bitwarden-ssh-agent.sock";
    "NIXOS_OZONE_WL" = "1";
  };

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
}
