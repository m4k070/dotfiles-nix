{ config, pkgs, noctalia, ... }: {
  imports = [
    noctalia.homeModules.default
  ];

  home.packages = with pkgs; [
    wdisplays
  ];

  services = {
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
          profile.name = "docked";
          profile.outputs = [
            { criteria = "$OFFICE"; position = "0,0"; }
            { criteria = "$INTERNAL"; position = "1920,0"; }
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
    gtk4.theme = null;
  };

  qt = {
    enable = true;
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  home.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.catppuccin-cursors.latteDark;
    name = "catppuccin-latte-dark-cursors";
    size = 24;
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {};
  };

  xdg.configFile."hypr/hyprland.lua".source = ../../configs/hypr/hyprland.lua;

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

  # GNOME 拡張機能（両ホスト共通）
  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.appindicator; }
    ];
  };

  xdg.configFile."niri/config.kdl".source = ../../configs/niri/config.kdl;
  xdg.configFile."starship.toml".source = ../../configs/starship/starship.toml;

  xdg.userDirs = {
    enable = true;
    setSessionVariables = false;
    desktop = "${config.home.homeDirectory}/Desktop";
    documents = "${config.home.homeDirectory}/Documents";
    download = "${config.home.homeDirectory}/Downloads";
    music = "${config.home.homeDirectory}/Music";
    pictures = "${config.home.homeDirectory}/Pictures";
    publicShare = "${config.home.homeDirectory}/Public";
    templates = "${config.home.homeDirectory}/Templates";
    videos = "${config.home.homeDirectory}/Videos";
  };
}
