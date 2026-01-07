{ config, pkgs, lib, ... }:
{

  programs.niri.enable = true;

  #programs.dankMaterialShell = {
  #  enable = true;

  #  systemd = {
  #    enable = true;
  #    restartIfChanged = true;
  #  };
  #};

  security.polkit.enable = true; # polkit
  services.gnome.gnome-keyring.enable = true; # secret service
  security.pam.services.swaylock = {};

#  programs.waybar.enable = true; # top bar
  environment.systemPackages = with pkgs; [
    #alacritty
    fuzzel 
    #swaylock 
    #mako 
    #swayidle 
    waybar
    xwayland-satellite # xwayland support
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
#  services = {
#    desktopManager.gnome.enable = true; # convenience
#    displayManager.gdm.enable = true;
#  };
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
