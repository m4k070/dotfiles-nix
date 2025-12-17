{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
    ];

    home = {
      packages = with pkgs; [
        alacritty
        fuzzel
        ghostty
        mako
        niri
        waybar
        wezterm
        wlogout
      ];
    };
    
    programs.waybar = {
      enable = true;
    };

    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        fontSize = 12;
        font-family = "UDEV Gothic";
        theme = "Kanagawa Wave";
      };
    };

    services.mako.enable = true;
    
    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
    xdg.configFile."mako/config".source = ../configs/mako/config.toml;
  }
