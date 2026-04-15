{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  services.displayManager.gdm.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  security.pam.services.gdm-password.enableGnomeKeyring = true;
  services.desktopManager.gnome.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-initial-setup
  ];
  services.udev.packages = with pkgs; [ gnome-settings-daemon ];
  environment.systemPackages = with pkgs; [
    gnomeExtensions.paperwm
    gnomeExtensions.appindicator
  ];
}
