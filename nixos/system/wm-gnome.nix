{ config, pkgs, lib, ... }:

{
    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm = {
        enable = true;

        #fractional-scaling is a mess but this will disable libinput and gesture, thus no.
        #wayland = false;
    };

    services.xserver.desktopManager.gnome = {
      enable = true;

      # better to have these down under home manager
      extraGSettingsOverrides = ''
      [org.gnome.desktop.input-sources]
      xkb-options="['ctrl:nocaps']"

      [org.gnome.mutter]
      experimental-features="['scale-monitor-framebuffer']"

      [org.gnome.desktop.peripherals.touchpad]
      tap-and-drag=false
      tap-to-click=true

      [org.gnome.desktop.wm.keybindings]
      switch-workspace-left="['<Super>Page_Up', '<Super><Control>Left']"
      switch-workspace-right="['<Super>Page_Down', '<Super><Control>Right']"
      move-to-workspace-left="['<Super><Shift>Page_Up', '<Super><Shift><Control>Left']"
      move-to-workspace-right="['<Super><Shift>Page_Down', '<Super><Shift><Control>Right']"
      '';
    };

  environment.systemPackages = with pkgs; [
    alacritty
    gnome3.gnome-tweaks
  ];
}
