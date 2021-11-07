{ config, lib, pkgs, ... } :
{

	environment.systemPackages = with pkgs; [ firefox-wayland ];
  	services.pipewire.enable = true;

	services = {
		xserver = {
			enable = true;
			#startDbusSession = true;
			layout = "us";

			libinput = {
				enable  = true;
				touchpad.disableWhileTyping = true;
				touchpad.naturalScrolling = true;
			};

			xkbOptions = "ctrl:nocaps";

			displayManager.sddm.enable = true;
			desktopManager.plasma5.enable = true;
		};
	};

}
