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
        niri
        waybar
        wezterm
        wlogout
      ];
    };
    
    programs.waybar = {
      enable = true;
      settings = [
        
      ];
    };
    
    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
    xdg.configFile."mako/config".source = ../configs/mako/config.toml;
  }
