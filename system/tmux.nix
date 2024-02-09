{ config, pkgs, lib, ...}:

{
    programs.tmux = {
        enable = true;
        shortcut = "b";
        keyMode = "vi";
        aggressiveResize = true;
        baseIndex = 1;
        # newSession = true;
        # stop tmux + escape craziness.
        escapeTime = 0;
        
        extraConfigBeforePlugins = (builtins.readFile ./.tmux.conf) + ''

set -g @resurrect-strategy-vim 'session'
set -g @resurrect-strategy-nvim 'session'
set -g @resurrect-capture-pane-contents 'on'

set -g @continuum-restore 'on'
set -g @continuum-boot 'on'
set -g @continuum-save-interval '5'
        '';

        plugins = with pkgs; [
            tmuxPlugins.sensible
            tmuxPlugins.resurrect
            tmuxPlugins.continuum
            tmuxPlugins.yank
            #tmuxPlugins.open
        ];

    };
}
