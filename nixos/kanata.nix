{ config, pkgs, ... }:

let
  kanata-config = pkgs.writeText "thinkpad.kbd" (builtins.readFile ./../configs/kanata/thinkpad.kbd);
in
{
  # Kanata keyboard remapper
  services.kanata = {
    enable = true;
    package = pkgs.kanata;
    keyboards = {
      thinkpad = {
        configFile = kanata-config;
        # Built-in keyboard only; external keyboards (e.g. Corne) are left ungrabbed
        devices = [ "/dev/input/by-path/platform-i8042-serio-0-event-kbd" ];
      };
    };
  };

  # Ensure uinput module is loaded
  boot.kernelModules = [ "uinput" ];

  # Add user to input group for uinput access
  users.users.makoto.extraGroups = [ "input" ];

  # Enable uinput group
  users.groups.uinput = {
    gid = 999;
    members = [ "makoto" ];
  };
}