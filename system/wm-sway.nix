{ config, pkgs, lib, ... }:

let 
    dbus-sway-environment = pkgs.writeTextFile {
        name = "dbus-sway-environment";
        destination = "/bin/dbus-sway-environment";
        executable = true;

        text = ''
        dbus-update-activation-environment  --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        '';
    };


# currently, there is some friction between sway and gtk:
# https://github.com/swaywm/sway/wiki/GTK-3-settings-on-Wayland
# the suggested way to set gtk settings is with gsettings
# for gsettings to work, we need to tell it where the schemas are
# using the XDG_DATA_DIR environment variable
# run at the end of sway config
    configure-gtk = pkgs.writeTextFile {
        name = "configure-gtk";
        destination = "/bin/configure-gtk";
        executable = true;
        text = let 
            schema = pkgs.gsettings-desktop-schemas;
            datadir = "${schema}/share/gsettings-schema/${schema.name}";
        in 
        ''
            export XDG_DATA_DIRS=${datadir}:$XDG_DATA_DIRS
            gnome_schema=org.gnome.desktop.interface
            gsettings set $gnome_schema gtk-theme 'Dracula'
        '';
    };

in
{
    environment.systemPackages = with pkgs; [
        #alacritty 
        sway
        dbus-sway-environment
        configure-gtk
        wayland
        glib #gsettings
        dracula-theme #gtk theme
        gnome3.adwaita-icon-theme #default gnome cursors
        swaylock
        swayidle
        grim
        slurp
        wl-clipboard
        wofi
        mako
    ];

    services.dbus.enable = true;
    services.xserver.displayManager.sddm.enable = true;
    #services.xserver.displayManager.extraSessionFilePackages = sway];

  hardware.opengl = {
      enable = true;
      driSupport = true;
  };

  xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
  };

  security.pam.services.swaylock = { 
      text = "auth include login";
  };

  programs.sway  = {
      enable = true;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      extraSessionCommands =''
      export MOZ_ENABLE_WAYLAND=1
      export HHHH='hhh'
      export XKB_DEFAULT_OPTIONS="ctrl:nocaps"
      '';
  };

}
