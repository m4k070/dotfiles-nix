{ lib, ... }:
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
    # NixOS統合時に home-manager.users.* が自動設定する値を優先させる
    username = lib.mkDefault username;
    homeDirectory = lib.mkDefault "/home/${username}";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  news.display = "silent";

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
