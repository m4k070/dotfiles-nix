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
    
    xdg.configFile."niri/config.kdl".source = ./config.kdl;
  }
