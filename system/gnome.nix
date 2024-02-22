{ config, pkgs, lib, ... }:

{  
    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager= {
        gdm = {
            enable = true;
            #autoSuspend = false;

        #fractional-scaling is a mess but this will disable libinput and gesture, thus no.
        #wayland = false;
        };
    };
    services.xserver.desktopManager.gnome = {
      enable = true;
    };

    # Required for ssh-askpass.
    programs.seahorse.enable = true;
    environment.gnome.excludePackages = (with pkgs; [
      #gnome-photos
      gnome-tour
      gedit
    ]) ++ (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      #gedit # text editor
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ]);

    environment.systemPackages = with pkgs; [
        adw-gtk3
        (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
        recursive
    ] ++ (with pkgs.gnome; [
        gnome-calculator
        gnome-calendar
        gnome-system-monitor
    ]) ++ (with pkgs.gnomeExtensions; [
        blur-my-shell
        dash-to-panel
        date-menu-formatter
    ]);

    programs.dconf.profiles = {
        user.databases = [{
            settings = with lib.gvarient; {
                # Use `$ dconf watch /` to watch the changes and apply those changes here.
                # gnome/dconf settings 
            };
        }];
    };







    # Gnome 40 introduced a new way of managing power, without tlp.
    # However, these 2 services clash when enabled simultaneously.
    # https://github.com/NixOS/nixos-hardware/issues/260
    services.power-profiles-daemon.enable = false;

}
