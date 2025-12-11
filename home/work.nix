{inputs, pkgs, nixgl, ...}:
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
        (config.lib.nixGL.wrap ghostty)
        (config.lib.nixGL.wrap wezterm)
        remmina
        teams-for-linux
      ];
    };
  }
