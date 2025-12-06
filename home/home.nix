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
    
    xdg.configFile."../configs/niri/config.kdl".source = ./config.kdl;
  }
