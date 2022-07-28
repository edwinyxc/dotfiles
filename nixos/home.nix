{ config, pkgs, ... }:
{
    home.username = "ed";
    home.homeDirectory = "/home/ed";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        bat
        gnumake clang 
        meson ninja
        rustup 

        #python
        
        #cli
        man-pages
        tree
        unzip zip
        zenith
        neofetch
        tealdeer
        gitui gitg

        #remote access
        remmina

        #xclip
        yarn nodejs nodePackages.npm

        #android
        #android-studio


    ];
   
    #java
    programs.java = {
        enable = true;
        # for better support for Intelij
        package = pkgs.jetbrains.jdk;
    };

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

    imports = [
        ./home/zsh.nix
        ./home/neovim.nix
    ];

    # Raw config files 
    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = ./home/config/alacritty.yml;

    home.stateVersion = "22.05";
}
