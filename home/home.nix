{ pkgs, ... }: {
  imports = [
    ./base.nix
  ];

  home.packages = with pkgs; [
    alacritty
    discord
    ghostty
    wezterm
    wlogout
  ];

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-size = 16;
      font-family = "UDEV Gothic";
      shell-integration-features = "ssh-env";
    };
  };

  xdg.configFile."waybar/config.jsonc".source = ../configs/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ../configs/waybar/style.css;
}
