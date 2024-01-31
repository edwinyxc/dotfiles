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
        enableZshIntegration = true;
    };
    
    programs.dircolors = {
        enable = true;
        enableZshIntegration = true;
    };

    programs.zsh = {
        enable = true;
        autocd = true;
        dotDir = ".config/zsh";

        enableAutosuggestions = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        sessionVariables = {
        };

        history = {
            expireDuplicatesFirst = true;
            ignoreSpace = false;
            save = 500000;
            share = true;
        };

        shellAliases = {
            sl = "eza";
            ls = "eza";
            l  = "eza -l";
            la = "eza -la";
            tmux = "tmux -u";

            #Questionable ideas
            find = "fd";
            grep = "rg";

            ip = "ip --color=auto";
            cat = "bat";
            tree = "ls --tree";
        };

        initExtraFirst =  ''
            ${builtins.readFile ./p10k-zsh-init-first.zsh}
        '';

        initExtra = ''
            ${builtins.readFile ./p10k-zsh-init.zsh}
            # default to emacs keybindings like bash.
            bindkey -e 
            export PATH=$HOME/.npm-global/bin:$PATH
        '';

        zplug = {
            enable = true;
            plugins = [
                { name = "zsh-users/zsh-autosuggestions"; }
                { name = "chisui/zsh-nix-shell"; }
                { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
                { name = "unixorn/fzf-zsh-plugin"; }
            ];
        };
    };

    programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
    };

}
