{inputs, pkgs, ...}:
  let
    inherit (import ./options.nix) username;
  in {
     imports = [
       ./base.nix
     ];

     home = {
       packages = with pkgs; [
         mangowc
         teams-for-linux
       ];
     };
  }
