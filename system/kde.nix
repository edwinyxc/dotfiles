{ config , pkgs , ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  #  deprecated in 6 
  #services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.displayManager.defaultSession = "plasma";

  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.naturalScrolling  = true;

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
      google-chrome
      libreoffice-qt
      mission-center
      neovide
      p3x-onenote
      joplin-desktop
      motrix
      onedrivegui
      zotero
  ];

  # vim friendly pdf reader
  programs.zathura.enable = true;

  # OneDrive
  services.onedrive.enable = true;

    programs.urxvt = {
        enable = true;
        fonts = [
            "xft:Blex Mono Nerd Font Mono:size=12"
            "xft:Monospace:size=12"
        ];
        scroll.lines = 10000;
        # You can adjust other URxvt options here
        extraConfig = {
                #! special
                background        = "#303446";
                foreground        = "#C6D0F5";
                cursorColor       = "#F2D5CF";

                #! black
                color0            = "#51576D";
                color8            = "#626880";

                #! red
                color1            = "#E78284";
                color9            = "#E78284";

                #! green
                color2            = "#A6D189";
                color10           = "#A6D189";

                #! yellow
                color3            = "#E5C890";
                color11           = "#E5C890";

                #! blue
                color4            = "#8CAAEE";
                color12           = "#8CAAEE";

                #! magenta
                color5            = "#F4B8E4";
                color13           = "#F4B8E4";

                #! cyan
                color6            = "#81C8BE";
                color14           = "#81C8BE";

                #! white
                color7            = "#B5BFE2";
                color15           = "#A5ADCE";

			# TODO color?
			# URxvt Appearance 
			letterSpace           = "0";
				lineSpace         = "0";
				geometry          = "122x35";
				internalBorder    = "12";
				cursorBlink       = "true";
				cursorUnderline   = "false";
				saveline          = "5000";
				scrollBar         = "false";
				scrollBar_right   = "false";
				urgentOnBell      = "true";
				depth             = "24";
				#Disable ISO 14755 unicode input so we can use Ctrl-Shift bindings 
				iso14755          = "false";
				iso14755_52       = "false";
				#Disable Ctrl-Alt-c & Ctrl-Alt-v bindings (optional)
				"keysym.C-M-c"    = "builtin-string:";
				"keysym.C-M-v"    = "builtin-string:";
				#Bind Ctrl-Shift-c & Ctrl-Shift-v to copy and paste # I dont know why, but I needed to use hex keysym values to get it to work 
				"keysym.C-S-0x43" = "eval:selection_to_clipboard";
				"keysym.C-S-0x56" = "eval:paste_clipboard";

        };
    };

}
