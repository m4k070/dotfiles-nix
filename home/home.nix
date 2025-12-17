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
        fuzzel
        ghostty
        #mako
        niri
        #swaybg
        #waybar
        wezterm
        wlogout
      ];
    };
    
    # programs.waybar = {
    #   enable = true;
    # };
    
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          widgets = {
            left = [
              {
                id = "CustomButton";
                leftClickExec = "noctalia-shell ipc call launcher toggle";
                leftClickUpdateText = false;
                icon = "rocket";
                hideMode = "alwaysExpanded";
                maxTextLength = {
                    horizontal = 10;
                    vertical = 10;
                };
                middleClickExec = "";
                middleClickUpdateText = false;
                parseJson = false;
                rightClickExec = "";
                rightClickUpdateText = false;
                showIcon = true;
                textCollapse = "";
                textCommand = "";
                textIntervalMs = 3000;
                textStream = false;
                wheelDownExec = "";
                wheelDownUpdateText = false;
                wheelExec = "";
                wheelMode = "unified";
                wheelUpExec = "";
                wheelUpUpdateText = false;
                wheelUpdateText = false;
              }
              {
                id = "ActiveWindow";
                colorizeIcons = false;
                hideMode = "hidden";
                maxWidth = 145;
                scrollingMode = "hover";
                showIcon = true;
                useFixedWidth = false;
              }
            ];
          };
        };
      };
    };

    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        font-size = 16;
        font-family = "UDEV Gothic";
        theme = "Kanagawa Wave";
      };
    };

    #services.mako.enable = true;
    
    xdg.configFile."niri/config.kdl".source = ../configs/niri/config.kdl;
    xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
    xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
    #xdg.configFile."mako/config".source = ../configs/mako/config.toml;
  }
