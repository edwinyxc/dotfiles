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

      	extraConfig = builtins.readFile ./.tmux.conf;
    };
}
