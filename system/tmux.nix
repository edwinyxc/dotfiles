{ config, pkgs, lib, ...}:

{
    programs.tmux = {
        enable = true;
        shortcut = "b";
        keyMode = "vi";
        aggressiveResize = true;
        baseIndex = 1;
        newSession = true;
        # stop tmux + escape craziness.
        escapeTime = 0;
        secureSocket = false;

        plugins = with pkgs; (with tmuxPlugins; [
          resurrect
          continuum
          yank
          catppuccin
          better-mouse-mode
        ]);
      
        extraConfig =  ''
## upgrade $TERM
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"

set -g mouse on
# Keep holding ctrl
bind-key ^D detach-client

bind -r H resize-pane -L 5
bind -r J resize-pane -D 5
bind -r K resize-pane -U 5
bind -r L resize-pane -R 5

# Smart pane switching with awareness of Vim splits.
# See: https://github.com/christoomey/vim-tmux-navigator
#is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
#    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
#bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
#bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
#bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
#
#bind 'C-l' run-shell "tmx display-message 'Ctrl_L is disabled in Vim'"
#
#bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
#
#tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
#if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
#    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
#if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
#    "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

bind-key -T copy-mode-vi 'C-h' select-pane -L
bind-key -T copy-mode-vi 'C-j' select-pane -D
bind-key -T copy-mode-vi 'C-k' select-pane -U
bind-key -T copy-mode-vi 'C-l' select-pane -R
bind-key -T copy-mode-vi 'C-\' select-pane -l

bind k selectp -U # switch to panel Up
bind j selectp -D # switch to panel Down 
bind h selectp -L # switch to panel Left
bind l selectp -R # switch to panel Right

bind c new-window -c "{#pane_current_path}"

set -g history-limit 10000
set -g status-interval 5

# fast split (hold ctrl)
bind-key v split-window -h -p 50 -c "#{pane_current_path}"
#bind-key ^V split-window -h -p 50 -c "#{pane_current_path}"
bind-key s split-window -p 50 -c "#{pane_current_path}"
#bind-key ^S split-window -p 50 -c "#{pane_current_path}"

####################[[PLUGINS]]##################
set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'

#set -g @resurrect-save 'S'
#set -g @resurrect-restore 'R'

#set -g @catppuccin_flavour 'latte' # or frappe, macchiato, mocha

set -g @continuum-restore 'on'
set -g @continuum-save-interval '5'
      '';

    };

    programs.bash.loginShellInit  = ''
    '';

}
