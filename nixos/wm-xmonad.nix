{ config, lib, pkgs, hdmiOn, ... } :
{
	programs.light.enable = true;
	programs.dconf.enable = true;

	environment.systemPackages = with pkgs; [
		rofi
		dmenu
		xmobar
		nitrogen
		dconf

		xclip
		xscreensaver

		qutebrowser

		playerctl 
		brightnessctl
	];

	services = {
		picom = {
			enable = true;
			fade = true;
			shadow = true;
			fadeDelta = 1;
				
			settings = {
				corner-radius = 10;
			};

			vSync = true;
		};

		gnome.gnome-keyring.enable = true;
		upower.enable = true;

		dbus = {
			enable = true;
			#socketActivated = true;
			packages = [ pkgs.gnome3.dconf ];
		};

		xserver = {
			enable = true;
			#startDbusSession = true;
			layout = "us";

			libinput = {
				enable  = true;
				touchpad.disableWhileTyping = true;
				touchpad.tappingDragLock = false;

				touchpad.naturalScrolling = true;
				#touchpad.accelProfile = "flat";

				touchpad.additionalOptions = ''
				Option "TappingDrag" "false"
				'';
			};


			displayManager = {
				#gdm = {
				#	enable = true;
				#	wayland = false;
				#};
				defaultSession = "none+xmonad";
			};

			windowManager.xmonad = {
				enable = true;
				enableContribAndExtras = true;
				extraPackages = hg: [
					hg.xmonad
					hg.xmonad-contrib
					hg.xmonad-extras
				];
			};

			xkbOptions = "ctrl:nocaps";
		};
	};

	hardware.bluetooth.enable = true;
	services.blueman.enable = true;
	systemd.services.upower.enable = true;
}
