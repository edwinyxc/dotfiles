{ config , pkgs , ... }:
{
	# Enable the X11 windowing system.
	services.xserver.enable = true;

	imports = [ 
                #./gnome.nix 
		./niri.nix 
		#./hyprland.nix 	
	];

	environment.systemPackages = with pkgs; [
		#crow-translate # 
		#Desktop apps goes here

		#google-chrome
		ungoogled-chromium
		libreoffice
		#onlyoffice-bin # not good on xwayland scaling

                #mission-center
                #neovide
		p3x-onenote
		#joplin-desktop
		#motrix
		#onedrivegui
		pinta
		zotero_7
		plantuml-c4

                thunderbird

		# evolution
                #evolution
		#evolution-ews
	];

        
        # XDG
        #xdg.portal.enable = true;

	# OneDrive
        #services.onedrive.enable = true;

	# Evolution
        #programs.evolution = {
	#	enable = true;
	#	plugins = [
	#		pkgs.evolution-ews
	#	];
	#};

        #services.gnome.evolution-data-server.enable = true;

#Since Nixos 22.05 you can turn on native wayland 
#support in all chrome and most electron apps by setting an environment variable:
	environment.sessionVariables = {
		#GDK_BACKEND = "wayland"; -- useless
		NIXOS_OZONE_WL = "1";
		MOZ_ENABLE_WAYLAND = "1";
		#Note Repo
		NOTES_DIR = "$HOME/OneDrive/notes";
	};
}
