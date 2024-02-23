{inputs, pkgs, ... }:
{
    #imports = [./urxvt.nix];

    # vim friendly pdf reader
    programs.zathura.enable = true;

    #terminal emulator FooT as an alternative to Urxvt which is not performing good under XWayland, while foot is Wayland native
    programs.foot = {
        enable = true;
        settings = {
            main = {
                term = "xterm-256color";
                font = "BlexMono Nerd Font Mono:size=9";
                dpi-aware = "yes"; 
            };
        };
    };
    
    home.file.".icons/default".source = "${pkgs.numix-cursor-theme}/share/icons/Numix-Cursor"; 
}
