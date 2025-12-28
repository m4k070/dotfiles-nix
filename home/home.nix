{inputs, pkgs, noctalia, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
    ];

    home = {
      packages = with pkgs; [
        alacritty
        ghostty
        #mako
        #swaybg
        #waybar
        wezterm
        wlogout
      ];
    };

    # programs.waybar = {
    #   enable = true;
    # };
    
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-size = 16;
        font-family = "UDEV Gothic";
        #theme = "noctalia";
      };
    };

    programs.git = {
      enable = true;
      settings.user.name = "Makoto Ito";
      settings.user.email = "m4k070@pm.me";
    };

    #services.mako.enable = true;
    
    xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
    #xdg.configFile."mako/config".source = ../configs/mako/config.toml;
  }
