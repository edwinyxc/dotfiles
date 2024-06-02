# bash.nix
{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
        bat
        eza
        lsd
        fd 
        file
        fzf
        ripgrep
        broot
        httpie
        procs
        cheat
        jq
    ];

    programs.fzf = {
        enable = true;
        enableBashIntegration = true;
        
    };
    
    programs.dircolors = {
        enable = true;
        enableBashIntegration = true;
    };

    programs.bash = {
        enable = true;
        #dotDir = ".config/zsh";

        enableCompletion = true;
        #syntaxHighlighting.enable = true;

        sessionVariables = {
            PROMPT_COMMAND="history -a";
        };

        historySize = 10000;

        initExtra = ''
        '';

        shellAliases = {
            sl = "eza";
            ls = "eza";
            l  = "eza -l";
            la = "eza -la";
            tmux = "tmux -u";

            #Questionable ideas
            find = "fd";
            #grep = "rg";

            ip = "ip --color=auto";
            #cat = "bat";
            tree = "ls --tree";

	    ".." = "cd ..";
        };

    };

    programs.direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
    };

}
