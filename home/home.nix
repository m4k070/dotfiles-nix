{ pkgs, ... }: {
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    alacritty
    android-tools
    cudaPackages.cudatoolkit
    davinci-resolve
    discord
    gamescope
    heroic
    (katago.override { backend = "cuda"; })
    katrain
    # Node.js (pokemon-champions-battle-engine MCP サーバー・シェル開発用)
    nodejs
    protonup-qt
    voicevox
    voicevox-engine
    wezterm
    wlogout
    xdg-user-dirs
  ];

  # Voicevox Engine (Hermes TTS 用、localhost:50021)
  systemd.user.services.voicevox-engine = {
    Unit = {
      Description = "VOICEVOX Engine";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.voicevox-engine}/bin/voicevox-engine --port 50021";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # gsconnect は vega の kdeconnect システム統合と連携する GNOME 拡張
  programs.gnome-shell.extensions = [
    { package = pkgs.gnomeExtensions.gsconnect; }
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
          cmd = "";
          detached = [
            "capsh --delamb=cap_sys_admin -- -c \"gamescope -W 1920 -H 1080 -w 1920 -h 1080 -f --steam -- steam steam://open/bigpicture\""
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
