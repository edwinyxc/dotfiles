{ config, pkgs, inputs, ... }:
let 
    #expose_bin_path = pkg : "${pkg.outPath}/bin";
    #exposePathsGlobally = ;
    pp = inputs.plenary-nvim;

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

        #Image Viewer
        geeqie
        
        #cli
        man-pages
        tree
        unzip zip
        #zenith
        neofetch
        tealdeer
        gitui gitg

        #remote access
        #remmina

        #xclip
        nodePackages.npm
        yarn 
        #android
        #android-studio

        # some devs deps that have to installed globally 
        # rustup 
        # nodePackages.gulp

        # MS OneNote
        p3x-onenote

        # MS Teams
        # teams

        joplin-desktop
        #joplin
    ];


    # vim friendly pdf reader
    programs.zathura.enable = true;
    



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
        ./zsh.nix
        ./neovim.nix
    ];


    # Raw config files 
    # Alacritty
    xdg.configFile."alacritty/alacritty.toml" = {
        source = ./config/alacritty.toml;
        force = true;
    };

    # Some softwares/extensions tend to read the default ~/.vimrc
    home.file.".vimrc".source = ./vimrc;

    # Wayland's initrc
    #xdg.configFile."environment.d/50-initrc.conf".text = ''
    #    PATH=$HOME/.npm-global/bin:$PATH
    #'';

    home.file.".npmrc".text = ''
        prefix=$HOME/.npm-global
    '';

    # home.file.".xprofile"

    home.stateVersion = "23.11";
}
