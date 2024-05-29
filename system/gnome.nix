{ config, pkgs, lib, ... }:
{

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	# Enable the GNOME Desktop Environment.
	services.xserver.displayManager= {
		gdm = {
			enable = true;
			#autoSuspend = false;

			#fractional-scaling is a mess, 
			#but this will disable libinput and gesture, thus no.
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
			#gedit
	]) ++ (with pkgs.gnome; [
		cheese # webcam tool
		gnome-music
		gnome-terminal
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
		#adw-gtk3
		(nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
			recursive
			gnome-frog
			remmina
			gedit
	] ++ (with pkgs.gnome; [
			gnome-calculator
			gnome-calendar
			gnome-system-monitor
			gnome-tweaks
			dconf-editor
	]) ++ (with pkgs.gnomeExtensions; [
#blur-my-shell
#dash-to-panel
#date-menu-formatter
#clipboard-indicator 
		clipboard-history
		user-themes
		numix-cursor-theme

		appindicator
	]);

	programs.dconf.profiles = {
		user.databases = [{
settings = with lib.gvariant; {
# Use `$ dconf watch /` to watch the changes and apply those changes here.
# gnome/dconf settings 
"org/gnome/mutter" = {
	experimental-features = [ "scale-monitor-framebuffer" ];
};

#Touchpad settings
"org/gnome/desktop/peripherals/mouse".accel-profile = "flat";
"org/gnome/desktop/peripherals/touchpad" = {
	tap-to-click = true;
	tap-and-drag = false;
	speed = 0.16831517509727634;
};

"org/gnome/desktop/privacy".remember-recent-files = false;

"org/gnome/desktop/interface" = {
	monospace-font-name = "BlexMono Nerd Font Medium:size=9";
	cursor-theme        = "Numix-Cursor";
	cursor-size         = mkInt32 18;
	icon-theme          = "Adwaita";
	gtk-theme           = "Adwaita";
};

"org/gnome/shell/keybindings".show-screen-recording-ui = ["<Shift><Super>s"];

"org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
	"/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
];

"org.gnome.desktop.wm.keybindings" = {
	show-desktop = ["<Super>d"];
	move-to-workspace-left = ["<Shift><Control><Super>Left"];
	move-to-workspace-right = ["<Shift><Control><Super>Right"];
	switch-to-workspace-left = ["<Control><Super>Left"];
	switch-to-workspace-right = ["<Control><Super>Right"];
};

"org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
	binding = "<Control><Alt>t";
#command = "foot";
	command = "kitty";
	name    = "Open Terminal";
};

"org/gnome/settings-daemon/plugins/power"= {
	ambient-enabled = false;
	idle-dim        = false;
};

# Extensions 
"org/gnome/shell".enabled-extensions = [
	"user-theme@gnome-shell-extensions.gcampax.github.com"
		"clipboard-history@alexsaveau.dev"
		"appindicatorsupport@rgcjonas.gmail.com"
];

"org/gnome/shell/extensions/user-theme" = {
	name = "";
};
};
		}];
	};


# Gnome 40 introduced a new way of managing power, without tlp.
# However, these 2 services clash when enabled simultaneously.
# https://github.com/NixOS/nixos-hardware/issues/260
	services.power-profiles-daemon.enable = false;

}
