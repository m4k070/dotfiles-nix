{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
    ];

    programs = {
      fuzzel.enable = true;
      swaylock.enable = true;
      waybar.enable = true;
    };
    services = {
      mako.enable = true;
      swayidle.enable = true;
      polkit-gnome.enable = true;
    };

    home = {
      packages = with pkgs; [
        blender
	swaybg
      ];
    };
    
    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
  }
