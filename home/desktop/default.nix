{inputs,lib, pkgs, ... }:
let 
	importFile = lib.strings.fileContents;
in {
	imports = [
		#./urxvt.nix

		# input method
                #./fcitx5
	];

	# vim friendly pdf reader
	programs.zathura = {
		enable = true;
		extraConfig = ''
# Synctex

#set synctex true
#set syctex-editor-command "nvim --remote-silent +%{line} %{input}"

# Basic Settings

set default-font-size 18

set highlight-transparency .1
set zoom-center "true"
set selection-clipboard clipboard
set render-loading "false"
# set window-width 960
set window-width 1280
set window-height 1080
set adjust-open "best-fit"

map <Space> toggle_index
map K zoom in
map J zoom out
map p print
map w recolor
map k 5k
map j 5k
map <C-v> toggle_fullscreen

set notification-error-bg       "#ebdbb2" # bg
set notification-error-fg       "#9d0006" # bright:red
set notification-warning-bg     "#ebdbb2" # bg
set notification-warning-fg     "#b57614" # bright:yellow
set notification-bg             "#ebdbb2" # bg
set notification-fg             "#79740e" # bright:green

set completion-bg               "#d5c4a1" # bg2
set completion-fg               "#3c3836" # fg
set completion-group-bg         "#ebdbb2" # bg1
set completion-group-fg         "#928374" # gray
set completion-highlight-bg     "#076678" # bright:blue
set completion-highlight-fg     "#d5c4a1" # bg2

# Define the color in index mode
set index-bg                    "#d5c4a1" # bg2
set index-fg                    "#3c3836" # fg
set index-active-bg             "#076678" # bright:blue
set index-active-fg             "#d5c4a1" # bg2

set inputbar-bg                 "#ebdbb2" # bg
set inputbar-fg                 "#3c3836" # fg

set statusbar-bg                "#d5c4a1" # bg2
set statusbar-fg                "#3c3836" # fg
set statusbar-v-padding         7

set highlight-color             "#b57614" # bright:yellow
set highlight-active-color      "#af3a03" # bright:orange

set default-bg                  "#1d2021" # bg
set default-fg                  "#3c3836" # fg
set render-loading              true
set render-loading-bg           "#ebdbb2" # bg
set render-loading-fg           "#3c3836" # fg

# Recolor book content's color
set recolor-lightcolor          "#ebdbb2" # bg
set recolor-darkcolor           "#3c3836" # fg
set recolor                     true
# set recolor-keephue             true      # keep original color
# set recolor-reverse-video       "true"
        '';
    };

    # terminal emulator FooT as an alternative to Urxvt which is not performing 
    # good under XWayland, while foot is Wayland native.

    #programs.foot = {
    #    enable = true;
    #    settings = {
    #        main = {
    #            term = "xterm-256color";
    #            font = "BlexMono Nerd Font Mono Medium:size=10";
    #            dpi-aware = "yes"; 
    #        };
    #    };
    #};

	programs.kitty = {
		enable = true;
		font = {
			#name = "BlexMono Nerd Font Mono Medium";
			name = "DSE Typewriter";
			size = 16;
		};
		extraConfig = ''

wayland_titlebar_color system
cursor_shape block
hide_window_decorations yes

		'';
	};

	#TODO single user anyway
	home.packages = with pkgs; [
		#whatsapp-for-linux
		pinta
	];

	home.file.".icons/default".source = 
		"${pkgs.numix-cursor-theme}/share/icons/Numix-Cursor"; 

	# make firefox treat md as text to avoid download
	home.file.".mime.types".text = ''
type=text/plain exts=md,mkd,mkdn,mdwn,mdown,markdown, desc="Markdown document"
		'';

}
