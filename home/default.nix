{ inputs, config, pkgs, _imports, ... }:
let 
    #expose_bin_path = pkg : "${pkg.outPath}/bin";
    #exposePathsGlobally = ;
    #pp = inputs.plenary-nvim; # TODO: not used

in
{
    home.username = "ed";
    home.homeDirectory = "/home/ed";
    programs.home-manager.enable = true;
    

    #TODO single user anyway
    home.packages = with pkgs; [
        texliveFull
        #whatsapp-for-linux
    ];

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
        #./zsh.nix
        ./bash.nix
        #./neovim.nix
        #./tmux.nix

    ] ++ _imports;

    #lightweight image viewer (require X)
    programs.feh = {
	    enable = true;
    };

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
    #xdg.configFile."zathura".source = ./zathurarc; -- use options instead

    # home.file.".xprofile"

    home.stateVersion = "23.11";

}
