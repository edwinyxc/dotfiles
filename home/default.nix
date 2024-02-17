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
        #alacritty

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

        motrix

        rustup
    ];


    # vim friendly pdf reader
    programs.zathura.enable = true;
    

    programs.urxvt = {
        enable = true;
        fonts = [
            "xft:Blex Mono Nerd Font Mono:size=12"
            "xft:Monospace:size=12"
        ];
        scroll.lines = 10000;
        # You can adjust other URxvt options here
        extraConfig = {
                #! special
                background        = "#303446";
                foreground        = "#C6D0F5";
                cursorColor       = "#F2D5CF";

                #! black
                color0            = "#51576D";
                color8            = "#626880";

                #! red
                color1            = "#E78284";
                color9            = "#E78284";

                #! green
                color2            = "#A6D189";
                color10           = "#A6D189";

                #! yellow
                color3            = "#E5C890";
                color11           = "#E5C890";

                #! blue
                color4            = "#8CAAEE";
                color12           = "#8CAAEE";

                #! magenta
                color5            = "#F4B8E4";
                color13           = "#F4B8E4";

                #! cyan
                color6            = "#81C8BE";
                color14           = "#81C8BE";

                #! white
                color7            = "#B5BFE2";
                color15           = "#A5ADCE";

			# TODO color?
			# URxvt Appearance 
			letterSpace           = "0";
				lineSpace         = "0";
				geometry          = "122x35";
				internalBorder    = "12";
				cursorBlink       = "true";
				cursorUnderline   = "false";
				saveline          = "5000";
				scrollBar         = "false";
				scrollBar_right   = "false";
				urgentOnBell      = "true";
				depth             = "24";
				#Disable ISO 14755 unicode input so we can use Ctrl-Shift bindings 
				iso14755          = "false";
				iso14755_52       = "false";
				#Disable Ctrl-Alt-c & Ctrl-Alt-v bindings (optional)
				"keysym.C-M-c"    = "builtin-string:";
				"keysym.C-M-v"    = "builtin-string:";
				#Bind Ctrl-Shift-c & Ctrl-Shift-v to copy and paste # I dont know why, but I needed to use hex keysym values to get it to work 
				"keysym.C-S-0x43" = "eval:selection_to_clipboard";
				"keysym.C-S-0x56" = "eval:paste_clipboard";

        };
    };

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
