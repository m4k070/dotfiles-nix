{inputs, pkgs, noctalia, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
      noctalia.homeModules.default
    ];

    home = {
      packages = with pkgs; [
        alacritty
        ghostty
        niri
        wezterm
      ];
    };
    
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true;
    };

    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    # xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    # xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
  }
