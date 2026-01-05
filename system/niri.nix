{ config, pkgs, lib, ... }:
{

  programs.niri.enable = true;

  programs.dankMaterialShell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };
  };

  #services.displayManager.dms-greeter.enable = true;
  #services = {
  #  desktopManager.gnome.enable = true; # convenience
  #  displayManager.gdm.enable = true;
  #};

  #services.power-profiles-daemon.enable = false;
}
