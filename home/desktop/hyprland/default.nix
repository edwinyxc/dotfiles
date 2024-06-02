{ inputs, config, lib, pkgs,  ... }:
let 
	toggle_menu = pkgs.writeScriptBin "toggle_menu" ''
#!/bin/sh
pkill rofi || rofi -combi-modi drun,window,ssh -show combi
	'';

	term = "kitty";
	fileManager = "nautilus";
	power_now = pkgs.writeScriptBin "power_now" ''
	'';

	importFile = lib.strings.fileContents;
in
{
	imports = [ 
		#./ags.nix 
	];
	home.packages = with pkgs; [
		toggle_menu
	];
	wayland.windowManager.hyprland = {
		enable = true;
		plugins = []; #TODO
		settings = {};

		extraConfig = ''

# See https://wiki.hyprland.org/Configuring/Monitors/

monitor=,preferred,auto,1.6

xwayland {
	force_zero_scaling = true
}

# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
exec-once = dbus-update-activation-environment --systemd -all

#[TODO] set mouse
#exec-once = hypr

exec-once = waybar 
exec-once = nm-applet
exec-once = blueman-applet

exec-once = hypridle

#[TODO] add 

exec-once = wl-paste --type text --watch cliphist store #Stores only text data
exec-once = wl-paste --type image --watch cliphist store #Stores only image data

# WIP testing
#exec-once = ags -b hypr

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf
# Set programs that you use
$terminal = kitty
$browser = firefox
$fileManager = nautilus
$menu = toggle_menu
# Some default env vars.
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct # change to qt6ct if you have that


# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
	kb_layout              =  us
	kb_variant             = 
	kb_model               = 
	kb_options             =  ctrl:nocaps
	kb_rules               =  
	follow_mouse           =  2
	touchpad {     
		natural_scroll =  yes                          
		#clickfinger_behavior  =  true                 
		drag_lock      =  true                         
		tap-and-drag   =  false        #  missing  on  wiki
	}                                                      
	sensitivity = 0 # -1.0 to 1.0, 0 means no modification.

	repeat_delay = 200
	repeat_rate = 30
}

general {
# See https://wiki.hyprland.org/Configuring/Variables/ for more

	gaps_in                =  0                               
	gaps_out               =  0                               
	border_size            =  1                               
	no_border_on_floating  =  true                            
	col.active_border      =  rgba(33ccffee)  rgba(00ff99ee)  45deg
	col.inactive_border    =  rgba(595959aa)                  
	resize_on_border       =  true                            
	layout                 =  dwindle                         
# Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
	allow_tearing = false
	extend_border_grab_area = 15
}


decoration {
# See https://wiki.hyprland.org/Configuring/Variables/ for more

	rounding = 0

	blur {
		enabled = true
		size = 3
		passes = 1
	}

	drop_shadow = yes
	shadow_range = 4
	shadow_render_power = 3
	col.shadow = rgba(1a1a1aee)
}

animations {
	enabled = yes

# Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

	bezier = myBezier, 0.05, 0.9, 0.1, 1.05

	animation = windows, 1, 7, myBezier
	animation = windowsOut, 1, 7, default, popin 80%
	animation = border, 1, 10, default
	animation = borderangle, 1, 8, default
	animation = fade, 1, 7, default
	animation = workspaces, 1, 6, default
}

dwindle {
# See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
	preserve_split = yes # you probably want this
}

master {
# See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	new_is_master = true
}

gestures {
	# See https://wiki.hyprland.org/Configuring/Variables/ for more
	workspace_swipe = on
	workspace_swipe_distance = 700
	workspace_swipe_fingers = 3
	workspace_swipe_cancel_ratio = 0.2
	workspace_swipe_min_speed_to_force = 5
	workspace_swipe_direction_lock = true
	workspace_swipe_direction_lock_threshold = 10
	workspace_swipe_create_new = true 
}

misc {
# See https://wiki.hyprland.org/Configuring/Variables/ for more
	force_default_wallpaper = 0 # Set to 0 or 1 to disable the anime mascot wallpapers
	vfr = true
	vrr = true
#new_window_takes_over_fullscreen = 1
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
device {
	name = epic-mouse-v1
	sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

#

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, return, exec, $terminal
bind = $mainMod SHIFT, Q, killactive, 
bind = $mainMod, W, exec, $browser
bind = $mainMod, F4, exit, 
bind = $mainMod, E, exec, $fileManager
bind = $mainMod, F, togglefloating
#bind = $mainMod SHIFT, F, workspaceopt, allfloat
#bind = $mainMod, V, togglefloating, 
bind = $mainMod, D, exec, $menu
#bindr = $mainMod, SUPER_L, exec, $menu
# bind = $mainMod, L, exec, swaylock
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle


bind = $mainMod, up, fullscreen, 1
bind = $mainMod, down, fullscreen, 0
bind = ALT, TAB, cyclenext
bind = ALT SHIFT, TAB, cyclenext, prev
bind = ALT, TAB, bringactivetotop 
bind = ALT SHIFT, TAB, bringactivetotop

# Move focus with mainMod + arrow keys
bind = $mainMod, H, movefocus, l
bind = $mainMod, L, movefocus, r
bind = $mainMod, U, movefocus, u
bind = $mainMod, K, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
# default workspace with firefox open
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3

# workspace, one the default to be float as default
bind = $mainMod SHIFT, 4, movetoworkspace, 4

#windowrulev2 = float, workspace:4

#
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9

# mail & other work/office staff
bind = $mainMod SHIFT, 0, movetoworkspace, 10
windowrulev2 = float, workspace:10

# Example special workspace (scratchpad)

bind = $mainMod, S, togglespecialworkspace, magic
bind = $mainMod SHIFT, S, movetoworkspace, special:magic
#windowrulev2 = float, workspace:spcial:magic


bind = $mainMod, A, togglespecialworkspace, term
bind = $mainMod SHIFT, A, movetoworkspace, special:term
workspace = special:term, on-created-empty:$terminal -e tmux a

# info 
bind = $mainMod, Q, togglespecialworkspace, Q
bind = $mainMod SHIFT, Q, movetoworkspace, special:Q

# special workspace control Ctrl-X
# 
bind = $mainMod, X, togglespecialworkspace, control 
bind = $mainMod SHIFT, X, movetoworkspace, special:control
workspace = special:control, on-created-empty: hyprctl dispatch workspaceopt allfloat
workspace = special:control, on-created-empty: pavucontrol 
#windowrule = workspace special:contrl, ^(.*OneDriveGUI*)$

# [start default]
#exec-once = OneDriveGUI

# TODO ..


# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow


#XF86
bindle = , XF86MonBrightnessUp, exec, brightnessctl set +5%
bindle = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bindle = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
bindle = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_SINK@ toggle
		'';
	};

	services.swaync = {
		enable = true;
		settings = "";
		style = "";
	};
	
	programs.waybar = {
		enable = true;
		#systemd.enable = ture;
settings = {
	mainBar = {
layer = "top";
position = "top";
height = 24;
margin = "6 6 2 6";
spacing = 2;

modules-left = [
	"custom/os"
	"hyprland/workspaces"
];

modules-center = [
	"clock"
	"idle_inhibitor"
];

modules-right = [
	"cpu" "memory" 
	"pulseaudio" "backlight" 
	"custom/power_now" "battery" 
	"tray"
];

"custom/os" = {
  "format" = " {} ";
  "exec" = ''echo "" '';
  "interval" = "once";
  "on-click" = "toggle_menu";
};

"custom/power_now" = {
	"format" = "{}";
	"interval" = 5; # every 5s seconds
	"exec" = "power_now";
};

"hyprland/workspaces" = {
	"format" = "{icon}";
	"format-icons" = {
		"1" = "*";
		"2" = "*";
		"3" = "*";
		"4" = "*";
		"5" = "*";
		"6" = "*";
		"7" = "*";
		"8" = "*";
		"9" = "*";
		"scratch_term" = "_";
		#TODO add more workspaces
	};
	"on-click" = "activate";
	"on-scroll-up" = "hyprctl dispatch workspace e+1";
	"on-scroll-down" = "hyprctl dispatch workspace e-1";
	"ignore-workspaces" = ["scratch" "-"];
};

"idle_inhibitor" = {
	format = "{icon}";
	format-icons = {
		activated = "󰅶";
		deactivated = "󰾪";
	};
};
tray = {
	"spacing" = 10;
};
clock = {
	"interval" = 60;
	"tooltip" = true;
	"format" = "{:%H:%M}";
	"timezone" = "Austrlia/Sydney";
	"tooltip-format" = " <tt><small>{calendar}</small></tt>";
	"calendar" = {
		mode = "month";
		mode-mon-col = 3;
	};
};
cpu = {
	"format" = "{usage}% ";
};
memory = { "format" = "{}% "; };
backlight = {
	"format" = "{percent}% {icon}";
	"format-icons" = [ "" "" "" "" "" "" "" "" "" ];
};
battery = {
	"states" = {
		"good" = 95;
		"warning" = 30;
		"critical" = 15;
	};
	"format" = "{capacity}% {icon}";
	"format-charging" = "{capacity}% ";
	"format-plugged" = "{capacity}% ";
#"format-good" = ""; # An empty format will hide the module
#"format-full" = "";
	"format-icons" = [ "" "" "" "" "" ];
};
pulseaudio = {
	"scroll-step" = 1;
	"format" = "{volume}% {icon}  {format_source}";
	"format-bluetooth" = "{volume}% {icon}  {format_source}";
	"format-bluetooth-muted" = "󰸈 {icon}  {format_source}";
	"format-muted" = "󰸈 {format_source}";
	"format-source" = "{volume}% ";
	"format-source-muted" = " ";
	"format-icons" = {
		"headphone" = "";
		"hands-free" = "";
		"headset" = "";
		"phone" = "";
		"portable" = "";
		"car" = "";
		"default" = [ "" "" "" ];
	};
	"on-click" = ''
	pypr toggle pavucontrol && 
	hyprctl dispatch bringactivetotop '';
};

	}; # mainBar
}; # settings

style = ''
${importFile ./waybar.style.css}
'';
	}; # waybar

home.file.".config/gtklock/style.css".text = ''
	windows {
		#background-image: url("'+[[TODO]]+'");
		#background-size: auto 100%
	}
'';

services.udiskie.enable = true;
services.udiskie.tray = "always";

programs.hyprlock.enable = true;
services.hypridle.enable = true;

# Files to be created manually
xdg.configFile."hypr/hyprlock/bat_status.sh".source = ./bat_status.sh; 
xdg.configFile."hypr/hypridle.conf".source = ./hypridle.conf; 
xdg.configFile."hypr/hyprlock.conf".source = ./hyprlock.conf; 

}
