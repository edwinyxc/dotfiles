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
        gitui

        #remote access
        remmina

        #xclip

        yarn nodejs
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

    imports = [
        ./home/zsh.nix
        ./home/neovim.nix
    ];

    # Raw config files 
    # Alacritty
    xdg.configFile."alacritty/alacritty.yml".source = ./home/config/alacritty.yml;

    home.stateVersion = "22.05";
}
