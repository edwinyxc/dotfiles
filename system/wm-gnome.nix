{ config, pkgs, lib, ... }:

{
    # Enable the X11 windowing system.
    services.xserver.enable = true;

    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm = {
        enable = true;

        #fractional-scaling is a mess but this will disable libinput and gesture, thus no.
        #wayland = false;
    };

    services.xserver.desktopManager.gnome = {
      enable = true;
    };

}
