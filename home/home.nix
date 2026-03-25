{ pkgs, ... }: {
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    alacritty
    discord
    ghostty
    heroic
    wezterm
    wlogout
  ];

  home.file.".config/sunshine/apps.json" = {
    text = builtins.toJSON {
      env = {
        PATH = "$(PATH):$(HOME)/.local/bin";
      };
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
          detached = [
            "gamescope -W 1920 -H 1080 -w 1920 -h 1080 -f --steam -- steam -bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "setsid steam steam://close/bigpicture";
            }
          ];
        }
      ];
    };
    # 書き込み可能にしておく（モジュールのバグを回避）
    force = true;
  };

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-size = 16;
      font-family = "UDEV Gothic";
      shell-integration-features = "ssh-env";
    };
  };

  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
}
