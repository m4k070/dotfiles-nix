# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../nixos/base.nix
      ../../nixos/gnome.nix
      ../../nixos/kanata.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  networking.hostName = "sirius"; # Define your hostname.
  networking.extraHosts = ''
  10.100.1.150 pvchecker.local
'';

  powerManagement.enable = true;
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
  };

  services.upower = {
    enable = true;
  };

  programs.niri = {
    enable = true;
  };

  programs.mangowc.enable = true;

  # ネットワークプリンター自動検出（mDNS）
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # RICOH IM C3510F（IPP Everywhere対応のためドライバー不要）
  hardware.printers = {
    ensurePrinters = [{
      name = "RICOH_IM_C3510F";
      location = "Office";
      deviceUri = "ipp://192.168.1.207/ipp/print";
      # "everywhere"はlpadminのIPP属性バリデーションが日本語テキストを拒否するため静的PPDを使用
      # pwgrast(Generic IPP Everywhere)は送信データエラーになるためPostScriptを使用
      model = "drv:///sample.drv/generic.ppd";
      ppdOptions = {
        PageSize = "A4";
      };
    }];
    ensureDefaultPrinter = "RICOH_IM_C3510F";
  };

}
