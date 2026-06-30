{ config, pkgs, noctalia, mango, ... }: {
  imports = [
    noctalia.homeModules.default
    mango.hmModules.mango
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
          output.alias = "MEETING";
        }
        {
          profile.name = "docked";
          profile.outputs = [
            { criteria = "$OFFICE"; position = "0,0"; }
            { criteria = "$INTERNAL"; position = "1920,0"; }
          ];
        }
        {
          profile.name = "office2";
          profile.outputs = [
            { criteria = "$OFFICE2"; position = "0,0"; }
            { criteria = "$INTERNAL"; position = "1920,0"; }
          ];
        }
        {
          profile.name = "office3";
          profile.outputs = [
            { criteria = "$OFFICE3"; position = "0,0"; }
            { criteria = "$INTERNAL"; position = "1920,0"; }
          ];
        }
        {
          profile.name = "meeting1";
          profile.outputs = [
            { criteria = "$INTERNAL"; position = "0,1080"; }
            { criteria = "$MEETING"; position = "0,0"; }
          ];
        }
        {
          profile.name = "meeting2";
          profile.outputs = [
            { criteria = "$MEETING"; position = "0,0"; }
            { criteria = "$INTERNAL"; position = "0,1080"; }
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

  wayland.windowManager.mango = {
    enable = true;
    package = pkgs.mangowc;
    systemd.enable = false;
    autostart_sh = ''
      noctalia &
      fcitx5 -d &
    '';
    settings = {
      blur = 0;
      blur_optimized = 1;
      shadows = 0;
      border_radius = 6;
      focused_opacity = 1.0;
      unfocused_opacity = 1.0;
      animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_duration_open = 400;
      animation_duration_close = 800;
      gappih = 5;
      gappiv = 5;
      gappoh = 10;
      gappov = 10;
      borderpx = 4;
      rootcolor = "0x201b14ff";
      bordercolor = "0x444444ff";
      focuscolor = "0xc9b890ff";
      repeat_rate = 25;
      repeat_delay = 600;
      tagrule = [
        "id:1,layout_name:tile"
        "id:2,layout_name:tile"
        "id:3,layout_name:tile"
        "id:4,layout_name:tile"
        "id:5,layout_name:tile"
        "id:6,layout_name:tile"
        "id:7,layout_name:tile"
        "id:8,layout_name:tile"
        "id:9,layout_name:tile"
      ];
      bind = [
        "SUPER,r,reload_config"
        "SUPER,t,spawn,ghostty"
        "SUPER,d,spawn,fuzzel"
        "SUPER+Alt,l,spawn,noctalia msg session lock"
        "SUPER,o,toggleoverview,"
        "SUPER,q,killclient,"
        "SUPER,Left,focusdir,left"
        "SUPER,Down,focusdir,down"
        "SUPER,Up,focusdir,up"
        "SUPER,Right,focusdir,right"
        "SUPER,h,focusdir,left"
        "SUPER,j,focusdir,down"
        "SUPER,k,focusdir,up"
        "SUPER,l,focusdir,right"
        "SUPER+CTRL,Left,exchange_client,left"
        "SUPER+CTRL,Down,exchange_client,down"
        "SUPER+CTRL,Up,exchange_client,up"
        "SUPER+CTRL,Right,exchange_client,right"
        "SUPER+CTRL,h,exchange_client,left"
        "SUPER+CTRL,j,exchange_client,down"
        "SUPER+CTRL,k,exchange_client,up"
        "SUPER+CTRL,l,exchange_client,right"
        "SUPER+SHIFT,Left,focusmon,left"
        "SUPER+SHIFT,Down,focusmon,down"
        "SUPER+SHIFT,Up,focusmon,up"
        "SUPER+SHIFT,Right,focusmon,right"
        "SUPER+SHIFT,h,focusmon,left"
        "SUPER+SHIFT,j,focusmon,down"
        "SUPER+SHIFT,k,focusmon,up"
        "SUPER+SHIFT,l,focusmon,right"
        "SUPER+SHIFT+CTRL,Left,tagmon,left"
        "SUPER+SHIFT+CTRL,Down,tagmon,down"
        "SUPER+SHIFT+CTRL,Up,tagmon,up"
        "SUPER+SHIFT+CTRL,Right,tagmon,right"
        "SUPER+SHIFT+CTRL,h,tagmon,left"
        "SUPER+SHIFT+CTRL,j,tagmon,down"
        "SUPER+SHIFT+CTRL,k,tagmon,up"
        "SUPER+SHIFT+CTRL,l,tagmon,right"
        "SUPER,Page_Up,viewtoleft,0"
        "SUPER,Page_Down,viewtoright,0"
        "SUPER,u,viewtoleft,0"
        "SUPER,i,viewtoright,0"
        "SUPER+CTRL,Page_Up,tagtoleft,0"
        "SUPER+CTRL,Page_Down,tagtoright,0"
        "SUPER+CTRL,u,tagtoleft,0"
        "SUPER+CTRL,i,tagtoright,0"
        "SUPER+SHIFT,Page_Up,tagtoleft,0"
        "SUPER+SHIFT,Page_Down,tagtoright,0"
        "SUPER+SHIFT,u,tagtoleft,0"
        "SUPER+SHIFT,i,tagtoright,0"
        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"
        "SUPER+CTRL,1,tag,1,0"
        "SUPER+CTRL,2,tag,2,0"
        "SUPER+CTRL,3,tag,3,0"
        "SUPER+CTRL,4,tag,4,0"
        "SUPER+CTRL,5,tag,5,0"
        "SUPER+CTRL,6,tag,6,0"
        "SUPER+CTRL,7,tag,7,0"
        "SUPER+CTRL,8,tag,8,0"
        "SUPER+CTRL,9,tag,9,0"
        "SUPER,r,set_proportion,1.0"
        "SUPER,f,togglemaximizescreen,"
        "SUPER+SHIFT,f,togglefullscreen,"
        "SUPER,v,togglefloating,"
        "SUPER,minus,resizewin,-50,+0"
        "SUPER,equal,resizewin,+50,+0"
        "SUPER+SHIFT,minus,resizewin,+0,-50"
        "SUPER+SHIFT,equal,resizewin,+0,+50"
        "SUPER,n,switch_layout"
        "SUPER,g,toggleglobal,"
        "SUPER+SHIFT,e,quit"
        "CTRL+ALT,Delete,quit"
        "NONE,Print,spawn,grimblast save output"
        "NONE,XF86AudioRaiseVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"
        "NONE,XF86AudioLowerVolume,spawn,wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"
        "NONE,XF86AudioMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        "NONE,XF86AudioMicMute,spawn,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        "NONE,XF86AudioPlay,spawn,playerctl play-pause"
        "NONE,XF86AudioStop,spawn,playerctl stop"
        "NONE,XF86AudioPrev,spawn,playerctl previous"
        "NONE,XF86AudioNext,spawn,playerctl next"
        "NONE,XF86MonBrightnessUp,spawn,brightnessctl --class=backlight set +10%"
        "NONE,XF86MonBrightnessDown,spawn,brightnessctl --class=backlight set 10%-"
      ];
      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
      axisbind = [
        "SUPER,UP,viewtoleft,0"
        "SUPER,DOWN,viewtoright,0"
        "SUPER+CTRL,UP,tagtoleft,0"
        "SUPER+CTRL,DOWN,tagtoright,0"
      ];
    };
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
