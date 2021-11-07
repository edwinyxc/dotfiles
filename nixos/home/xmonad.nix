{ config, lib, pkgs, hdmiOn, ... } :
{
	xresources.properties = {	
		"Xft.dpi" = 144;
		"Xft.autohint" = 0;
		"Xft.hintstyle" = "hintfull";
		"Xft.hinting" = 1;
		"Xft.antialias" = 1;
		"Xft.rgba" = "rgb";
		"Xcursor*theme" = "Adwaita";
		"Xcursor*size" = 48;
	};

	home.sessionVariables = {
		# GDK_SCALE=2;
		# GDK_DPI_SCALE=0.5;
		QT_SCALE_FACTOR=1.5;
	};

	#home.file.".icons/default".source = ""

	xsession = {
		enable = true;
		windowManager.xmonad = {
			enable = true;
			enableContribAndExtras = true;
			extraPackages = hp: [
				hp.dbus
				hp.monad-logger
				hp.xmonad-contrib
				hp.xmobar
			];
			config = ./xmonad.hs;
		};

	};

	gtk.enable = true;
	gtk.gtk3.extraConfig = {
		gtk-cursor-theme-name = "Adwaita";
		gtk-cursor-theme-size = 48;
	};

	programs.rofi = {
		enable = true;
		terminal = "${pkgs.alacritty}/bin/alacritty";
	};

	programs.xmobar = {
		enable = true;
		extraConfig = (builtins.readFile ./xmobarrc);
	};
}
