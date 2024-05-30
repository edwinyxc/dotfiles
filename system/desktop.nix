{ config , pkgs , ... }:
{
	# Enable the X11 windowing system.
	services.xserver.enable = true;

	imports = [ 
		#./gnome.nix 

	# [ Tue 28 May 2024 04:22:51 AEST]
	# WIP not stable yet 
		./hyprland.nix 	
	];

	# fcitx 5
	#i18n.inputMethod = {
	#  enabled = "fcitx5";
	#  fcitx5.addons = with pkgs; [
	#      fcitx5-mozc
	#      fcitx5-gtk
	#  ];
	#};

	environment.systemPackages = with pkgs; [
		#crow-translate # 
		#Desktop apps goes here
		#google-chrome
		libreoffice

		mission-center
		#onlyoffice-bin
		neovide
		p3x-onenote
		joplin-desktop
		motrix
		#onedrivegui
		zotero_7
		plantuml-c4
		evolution
		evolution-ews
	];

	# OneDrive
	services.onedrive.enable = true;

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
