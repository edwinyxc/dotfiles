{ inputs, config, pkgs, _imports, ... }:
let 
    #expose_bin_path = pkg : "${pkg.outPath}/bin";
    #exposePathsGlobally = ;
    pp = inputs.plenary-nvim; # TODO: not used

in
{
    home.username = "ed";
    home.homeDirectory = "/home/ed";
    programs.home-manager.enable = true;
    

    #TODO single user anyway
    home.packages = with pkgs; [ ];

    ##java
    #programs.java = {
    #    enable = true;
    #    # for better support for Intelij
    #    package = pkgs.jetbrains.jdk;
    #};

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
    ] ++ _imports;


    # Raw config files 
    # Alacritty
    #xdg.configFile."alacritty/alacritty.toml" = {
    #    source = ./config/alacritty.toml;
    #    force = true;
    #};

    # Some softwares/extensions tend to read the default ~/.vimrc
    home.file.".vimrc".source = ../system/vimrc;

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
