{inputs, pkgs, ... }:
{
    imports = [./urxvt.nix];

    # vim friendly pdf reader
    programs.zathura.enable = true;

}
