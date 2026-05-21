{ config, pkgs, noctalia, nixgl, ... }: {
  imports = [
    ./base.nix
    ./modules/work-common.nix
  ];

  # nixGL を使ってGPUドライバーをラップする（非NixOS環境向け）
  targets.genericLinux.nixGL.packages = import nixgl {
    inherit pkgs;
  };
  targets.genericLinux.nixGL.defaultWrapper = "mesa";
  targets.genericLinux.nixGL.installScripts = [ "mesa" ];

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap alacritty)
    (config.lib.nixGL.wrap wezterm)
    libreoffice
    remmina
    teams-for-linux
    warp-terminal
    zoom-us
  ];

  programs.ghostty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.ghostty;
    enableZshIntegration = true;
    settings = {
      font-size = 14;
      font-family = "UDEV Gothic";
      theme = "Earthsong";
      shell-integration-features = "ssh-env";
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      { package = pkgs.gnomeExtensions.paperwm; }
    ];
  };
}
