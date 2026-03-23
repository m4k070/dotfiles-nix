{ config, pkgs, noctalia, nix-hazkey, ... }: {
  imports = [
    noctalia.homeModules.default
    nix-hazkey.homeModules.hazkey
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
  };

  services = {
    hazkey.enable = true;

    gnome-keyring.enable = true;

    udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.nautilus}/bin/nautilus";
        };
      };
    };

    kanshi = {
      enable = true;
      settings = [
        {
          output.criteria = "AU Optronics 0xFA9B Unknown";
          output.scale = 1.25;
          output.mode = "1920x1200@60.026";
          output.alias = "INTERNAL";
        }
        {
          output.criteria = "Iiyama North America PL2492H 1225743345900";
          output.scale = 1.0;
          output.mode = "1920x1080@100.000";
          output.alias = "OFFICE";
        }
        {
          output.criteria = "ASUSTek COMPUTER INC PA278QV MALMQS119530";
          output.scale = 1.0;
          output.mode = "2560x1440@59.951";
          output.alias = "HOME";
        }
        {
          output.criteria = "HP Inc. HP Z24n G2 6CM9490RTY";
          output.scale = 1.0;
          output.mode = "1920x1200@59.950";
          output.alias = "OFFICE2";
        }
        {
          output.criteria = "Philips Consumer Electronics Company PHL 223V5 ZV02022003835";
          output.scale = 1.0;
          output.mode = "1920x1080@60.000";
          output.alias = "OFFICE3";
        }
        {
          output.criteria = "PNP(XMD) Mi TV 0x00000001";
          output.scale = 2.0;
          output.mode = "3840x2160@60.000";
          output.alias = "MEETING1";
        }
        {
          profile.name = "docked";
          profile.outputs = [
            { criteria = "$INTERNAL"; position = "1920,0"; }
            { criteria = "$OFFICE"; position = "0,0"; }
          ];
        }
        {
          profile.name = "office2";
          profile.outputs = [
            { criteria = "$INTERNAL"; position = "1920,0"; }
            { criteria = "$OFFICE2"; position = "0,0"; }
          ];
        }
        {
          profile.name = "office3";
          profile.outputs = [
            { criteria = "$INTERNAL"; position = "0,0"; }
            { criteria = "$OFFICE3"; position = "1920,0"; }
          ];
        }
        {
          profile.name = "meeting1";
          profile.outputs = [
            { criteria = "$INTERNAL"; position = "0,2160"; }
            { criteria = "$MEETING1"; position = "0,0"; }
          ];
        }
        {
          profile.name = "home";
          profile.outputs = [
            { criteria = "$HOME"; }
          ];
        }
      ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Tokyonight-Dark";
      package = pkgs.tokyonight-gtk-theme;
    };
  };

  qt = {
    enable = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.latteDark;
    name = "catppuccin-latte-dark-cursors";
    size = 24;
  };

  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
  };

  programs.starship = {
    enable = true;
  };

  programs.vivaldi = {
    enable = true;
    commandLineArgs = [
      "--enable-features=UseOzonePlatform"
      "--ozone-platform=wayland"
      "--enable-wayland-ime"
    ];
  };

  xdg.enable = true;
  xdg.mime.enable = true;

  xdg.configFile."niri/config.kdl".source = ../../configs/niri/config.kdl;
  xdg.configFile."starship.toml".source = ../../configs/starship/starship.toml;
  xdg.configFile."yazi/theme.toml".source = ../../configs/yazi/theme.toml;

  xdg.userDirs = {
    download = "${config.home.homeDirectory}/Downloads";
    pictures = "${config.home.homeDirectory}/Pictures";
  };
}
