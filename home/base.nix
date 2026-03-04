{ ... }:
let
  inherit (import ./options.nix) username;
in {
  imports = [
    ./modules/shell.nix
    ./modules/editor.nix
    ./modules/git.nix
    ./modules/desktop.nix
    ./modules/packages.nix
  ];

  home = {
    username = username;
    homeDirectory = "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  news.display = "silent";
}
