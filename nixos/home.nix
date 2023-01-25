{ config, pkgs, ... }:
let 
    #expose_bin_path = pkg : "${pkg.outPath}/bin";
    #exposePathsGlobally = ;
in
{
    home.username = "ed";
    home.homeDirectory = "/home/ed";
    programs.home-manager.enable = true;

    home.packages = with pkgs; [
        alacritty
        bat
        gnumake clang 
        meson ninja

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
        nodePackages.npm
        yarn 
        #android
        #android-studio

        # some devs deps that have to installed globally 
        rustup 
        # nodePackages.gulp
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

    # Some softwares/extensions tend to read the ~/.vimrc
    home.file.".vimrc".source = ./home/vimrc;

    # Wayland's initrc
    #xdg.configFile."environment.d/50-initrc.conf".text = ''
    #    PATH=$HOME/.npm-global/bin:$PATH
    #'';

    home.file.".npmrc".text = ''
        prefix=$HOME/.npm-global
    '';

    # home.file.".xprofile"

    home.stateVersion = "22.05";
}
