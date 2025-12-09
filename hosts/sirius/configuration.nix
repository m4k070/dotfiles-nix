# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ../../nixos/base.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # Define your hostname.
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;
}
