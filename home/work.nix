{config, pkgs, nixgl, ...}:
  let
    inherit (import ./options.nix) username;
  in {
    imports = [
      ./base.nix
    ];

    # This code is required to enable nixGL
    targets.genericLinux.nixGL.packages = import nixgl {
      inherit pkgs;
    };
    targets.genericLinux.nixGL.defaultWrapper = "mesa";  # or whatever wrapper you need
    targets.genericLinux.nixGL.installScripts = [ "mesa" ];

    home = {
      packages = with pkgs; [
        (config.lib.nixGL.wrap alacritty)
        (config.lib.nixGL.wrap wezterm)
        remmina
        teams-for-linux
      ];
    };

    programs.ghostty = {
      enable = true;
      package = config.lib.nixGL.wrap pkgs.ghostty;
      enableZshIntegration = true;
      settings = {
        font-size = 14;
        font-family = "UDEV Gothic";
        theme = "Kanagawa Wave";
      };
    };
  }
