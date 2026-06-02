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
  # GNOME 拡張機能のパッケージ・有効化は home-manager の programs.gnome-shell で管理する
  programs.dconf.enable = true;
}
