# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [
      ../../nixos/base.nix
      ../../nixos/gnome.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  nixpkgs.overlays = [
    (import ../../katrain-nix/katrain-overlay.nix)
  ];

  networking.hostName = "vega"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    android-tools
    gnomeExtensions.gsconnect
    cudaPackages.cudatoolkit
    gamescope
    (pkgs.katago.override { backend = "cuda"; })
    katrain
    pipx
    protonup-qt
    sunshine
  ];

  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  programs.niri.enable = true;
  services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 32;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 32;
    };
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
      cudaPackages = pkgs.cudaPackages;
    };
  };

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia-container-toolkit.enable = true;

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ]; # Helpful for network scanners
  services.udev.packages = [ pkgs.brscan5 ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
