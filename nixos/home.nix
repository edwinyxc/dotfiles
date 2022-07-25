{ config, pkgs, ... }:
{
    home.username = "ed";
    home.homeDirectory = "/home/ed";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        bat
        gnumake
        meson ninja
        rustup 

        #python
        
        #cli
        exa fd file fzf man-pages 
        zenith
        neofetch

        ripgrep
        tree
        unzip zip
        #xclip
        gitui

    ];
   
    programs.git = {
        enable = true;

        package = pkgs.gitAndTools.gitFull;
        userName = "edwinyxc";
        userEmail = "edwinyxc@outlook.com";
        extraConfig = {
            core.editor = "vim";
            credential.helper = "cache";
        };
    };

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
        enableSyntaxHighlighting = true;

        sessionVariables = {
        };

        history = {
            expireDuplicatesFirst = true;
            ignoreSpace = false;
            save = 500000;
            share = true;
        };

        shellAliases = {
            sl = "exa";
            ls = "exa";
            l  = "exa -l";
            la = "exa -la";
            ip = "ip --color=auto";
            cat = "bat";
            tree = "ls --tree";
        };

        initExtraFirst =  ''
            ${builtins.readFile ./home/p10k-zsh-init.zsh}
        '';

        initExtra = ''
            ${builtins.readFile ./home/p10k-zsh-init.zsh}
            # default to emacs keybindings like bash.
            bindkey -e 
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

    # Raw config files 
    # Alacritty
    
    xdg.configFile."alacritty/alacritty.yml".source = ./home/config/alacritty.yml;

    home.stateVersion = "22.05";
}
