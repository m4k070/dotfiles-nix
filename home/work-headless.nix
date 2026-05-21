{ config, pkgs, ... }:
let
  inherit (import ./options.nix) username;
in {
  imports = [
    ./modules/shell.nix
    ./modules/git.nix
    ./modules/editor-common.nix
    ./modules/packages-common.nix
    ./modules/work-common.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
  news.display = "silent";

  programs.starship.enable = true;

  xdg.enable = true;
  xdg.configFile."starship.toml".source = ../configs/starship/starship.toml;
}
