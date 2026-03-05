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

  networking.hostName = "vega"; # Define your hostname.

  environment.systemPackages = with pkgs; [
    cudaPackages.cudatoolkit
    gamescope
    heroic
    protonup-qt
    sunshine
  ];

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
    applications = {
      apps = [
        {
          name = "Desktop";
          image-path = "desktop.png";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
          wait-all = "true";
          exit-timeout = "5";
        }
        {
          name = "Steam Big Picture";
          image-path = "steam.png";
          exclude-global-prep-cmd = "false";
          auto-detach = "true";
          wait-all = "true";
          exit-timeout = "5";
          detached = [
            "setsid gamescope -W \${SUNSHINE_CLIENT_WIDTH} -H \${SUNSHINE_CLIENT_HEIGHT} -w \${SUNSHINE_CLIENT_WIDTH} -h \${SUNSHINE_CLIENT_HEIGHT} -f --steam -- steam -bigpicture"
          ];
          prep-cmd = [
            {
              do = "";
              undo = "setsid steam steam://close/bigpicture";
            }
          ];
        }
      ];
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
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamemode.enable = true;
}
