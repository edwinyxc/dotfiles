{ config, lib, pkgs, ... } :
{

	environment.systemPackages = with pkgs; [ firefox-wayland ];
	services = {
		xserver = {
			enable = true;
			#startDbusSession = true;
			layout = "us";

			libinput = {
				enable  = true;
				touchpad.disableWhileTyping = true;
				touchpad.naturalScrolling = true;
				#touchpad.accelProfile = "flat";
			};

			xkbOptions = "ctrl:nocaps";

			displayManager.gdm.enable = true;
			displayManager.gdm.wayland = true;
			desktopManager.gnome.enable = true;
		};
	};

	environment.gnome.excludePackages = with pkgs; [
		gnome.gnome-terminal
		gnome-photos
		gnome.gnome-music
		gnome.cheese
		gnome-tour
	];

	programs.dconf.enable = true;

}
