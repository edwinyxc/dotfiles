
{ config, lib, pkgs, hdmiOn, ... } :
{

	environment.systemPackages = with pkgs; [ firefox-wayland ];
	environment.sessionVariables = {
#MOZ_ENABLE_WAYLAND = 1;
		XKB_DEFAULT_OPTIONS = ctrl:nocaps;
	};

  	services.pipewire.enable = true;

	programs.sway = {
		enable = true;
		wrapperFeatures.gtk = true; # so that gtk works
		extraPackages = with pkgs; [
			swaylock
			swayidle
			wl-clipboard
			mako #notification daemon
			dmenu #or wofi?
		];
	};
}
