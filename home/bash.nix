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
	wl-clipboard
	ripgrep
        tree-sitter
        jq 
        curl
        universal-ctags
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
		XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
                #CONDA_VIRTUAL_ENV = "";
        };

        historySize = 10000;

        initExtra = ''
        '';

        bashrcExtra = ''
        '';

        shellAliases = {
            sl = "eza";
            ls = "eza";
            l  = "eza -l";
            la = "eza -la";
            tmux = "tmux -u";

            #Questionable ideas
            #find = "fd";
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
