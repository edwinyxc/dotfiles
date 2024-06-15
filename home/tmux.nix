# tmux.nix
{ config, pkgs, ... }:
let 
	tmux-save = pkgs.writeShellScriptBin "tmux-save" ''
#!/usr/bin/env bash

SAVE_SH=${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/save.sh

if [ "$(pgrep tmux)" ]; then
	echo "Start saving by $SAVE_SH" 
	$SAVE_SH 
	echo "Done!"
fi

	'';
	tmux-restore = pkgs.writeShellScriptBin "tmux-restore" ''
#!/usr/bin/env bash

SAVE_SH=${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh

if [ "$(pgrep tmux)" ]; then
	echo "Start resotre by $SAVE_SH" 
	$SAVE_SH 
	echo "Done!"
fi

	'';
in
{

	programs.tmux = {
		enable = true;
		terminal = "tmux-256color";
		historyLimit = 100000;
		plugins = with pkgs; (with tmuxPlugins; [
{
	plugin =resurrect;
	extraConfig = ''
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'
'';
}

{
	plugin = continuum;
	extraConfig = ''
set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'

'';
}

	yank

{
	plugin = catppuccin;
	extraConfig = ''
set -g @catppuccin_flavour 'latte' # or frappe, macchiato, mocha
'';
}

#{
#	plugin = tmux-super-fingers;
#	extraConfig = "set -g @super-fingers-key f";
#}

	better-mouse-mode
]);
	extraConfig = ''
## upgrade $TERM
set -g default-terminal "tmux-256color"
set-option -sa terminal-overrides ',xterm-256color:RGB'

set-option -g mouse on
set-window-option -g mode-keys vi
set -g status-keys vi
set -g bell-action any

# Keep holding ctrl
bind-key ^D detach-client
# fast split
bind-key v split-window -h -p 50 -c "#{pane_current_path}"
bind-key ^V split-window -h -p 50 -c "#{pane_current_path}"
bind-key s split-window -p 50 -c "#{pane_current_path}"
bind-key ^S split-window -p 50 -c "#{pane_current_path}"

bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l

bind k selectp -U # switch to panel Up
bind j selectp -D # switch to panel Down 
bind h selectp -L # switch to panel Left
bind l selectp -R # switch to panel Right


set-option -g base-index 1
set-window-option -g pane-base-index 1

set-option -g status-interval 2

# No escape time for vi-mode
set -sg escape-time 0

bind c new-window -c "{#pane_current_path}"

#utf8 is on
#set -g utf8 on
#set -g status-utf8 on
## address vim mode switching delay (http://superuser.com/a/252717/65504)
#set -s escape-time 0

## increase scrollback buffer size
set -g history-limit 50000
#
## tmux messages are displayed for 4 seconds
set -g display-time 4000
#
## refresh 'status-left' and 'status-right' more often
set -g status-interval 5
#
## set only on OS X where it's required
#set -g default-command "reattach-to-user-namespace -l $SHELL"
#
#set -g escape-time 10
#
## emacs key bindings in tmux command prompt (prefix + :) are better than
## vi keys, even for vim users
#set -g status-keys emacs
#
## focus events enabled for terminals that support them
set -g focus-events on

# super useful when using "grouped sessions" and multi-monitor setup
setw -g aggressive-resize on
	'';
};
	home.packages = [
		tmux-save
		tmux-restore
	];

	systemd.user.services.tmux-autosave = {
		#path = [pkgs.bash tmux-save];
		Unit = {
			Description = "Run tmux_resurrect save script every 15 minutes";
			OnFailure = "error@%n.service";
		};
		Service = {
			Type = "oneshot";
			ExecStart = "${pkgs.bash}/bin/bash tmux-save";
		};
	};
	systemd.user.timers.tmux-autosave = {
		Unit = {
			Description = "Run tmux_resurrect save script every 15 minutes";
		};
		Timer = {
			OnBootSec = "5min";
			OnUnitActiveSec = "15min";
			Unit = "tmux-autosave.service";
		};
		Install = {
			WantedBy = [ "timers.target" ];
		};
	};

}
