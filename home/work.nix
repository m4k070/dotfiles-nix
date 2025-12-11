{config, pkgs, nixgl, noctalia, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
      noctalia.homeModules.default
    ];

    # This code is required to enable nixGL
    targets.genericLinux.nixGL.packages = import nixgl {
      inherit pkgs;
    };
    targets.genericLinux.nixGL.defaultWrapper = "mesa";  # or whatever wrapper you need
    targets.genericLinux.nixGL.installScripts = [ "mesa" ];

    programs.noctalia-shell = {
      enable = true;
      systemd.enable = false;
    };

    home = {
      packages = with pkgs; [
        (config.lib.nixGL.wrap alacritty)
        (config.lib.nixGL.wrap ghostty)
        (config.lib.nixGL.wrap wezterm)
        remmina
        teams-for-linux
      ];
    };
  }
