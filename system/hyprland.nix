{ config, pkgs, lib, ... }:
{
	# Enable the X11 windowing system.
	#services.xserver.enable = true;

	services.displayManager.sddm = {
		enable = true;
		wayland.enable = true;
		enableHidpi = true;
		theme = "chili";
	};

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
		portalPackage = pkgs.xdg-desktop-portal-hyprland;
	};

	services.blueman.enable = true;
	#services.gnome3.gnome-keyring.enable = true;

	services.libinput.enable = true;
	services.libinput.touchpad.disableWhileTyping = true;
	services.libinput.touchpad.naturalScrolling  = true;


	services.dbus = {
		enable = true;
		packages = [pkgs.dconf];
	};

	programs.dconf.enable = true;
	
	environment.systemPackages = with pkgs; 
	with gnome;[
		wayland
		waydroid
		polkit_gnome
		gsettings-desktop-schemas

		sddm-chili-theme #TODO

		glib
		xdg-utils
		xorg.xrdb
		gnupg
		imagemagick
		swappy
		slurp

		loupe
		nautilus
		baobab
		bun
		gnome-text-editor
		gnome-calendar
		gnome-boxes
		gnome-system-monitor
		gnome-control-center
		gnome-weather
		gnome-calculator
		gnome-clocks
		gnome-software # for flatpak

		gtk3
		networkmanager
		networkmanager_dmenu
		networkmanagerapplet

		morewaita-icon-theme
		adwaita-icon-theme
		qogir-icon-theme


		wl-gammactl
		wl-clipboard
		cliphist

		rofi-wayland
		waybar

		pavucontrol
		brightnessctl
		playerctl
		#swww


		    hyprpaper
		    hyprlock
		    hypridle

		hyprcursor
		hyprpicker
		hyprland-protocols

		qt6.qtwayland
		xdg-utils
		xdg-desktop-portal
		xdg-desktop-portal-gtk
		xdg-desktop-portal-hyprland
		xwaylandvideobridge
		
		xdotool
		dunst
	];

	xdg.portal = {
		enable = true;
		extraPortals = with pkgs; [
			xdg-desktop-portal-gtk
		];
	};

	security = {
		polkit.enable = true;
		pam.services.hyprlock = {};
		pam.services.login.enableGnomeKeyring = true;
	};

	services = {
		gvfs.enable = true;
		devmon.enable = true;
		udisks2.enable = true;
		upower.enable = true;
		#power-profiles-daemon.enable = true;
		#accounts-daemon.enable = true;
		gnome = {
			evolution-data-server.enable = true;
			glib-networking.enable = true;
			gnome-keyring.enable = true;
			gnome-online-accounts.enable = true;
		};
	};


	
}
