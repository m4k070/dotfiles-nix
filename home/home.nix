{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
    ];

    home = {
      packages = with pkgs; [
        blender
      ];
    };
    
    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    # xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    # xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
  }
