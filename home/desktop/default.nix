{inputs, pkgs, ... }:
{
    imports = [./urxvt.nix];

    # vim friendly pdf reader
    programs.zathura.enable = true;

    # Use `dconf watch /` to track stateful changes you are doing, then set them here.
    dconf.settings = {
        "org/gnome/desktop/interface" = {
            #color-scheme = "prefer-dark";
        };
    };

}
