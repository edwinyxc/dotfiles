{ pkgs, lib, config, ...}:
{
    fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        fonts = with pkgs; [
          corefonts # Microsoft free fonts
          font-awesome
          powerline-fonts

          noto-fonts
          noto-fonts-cjk-serif
          noto-fonts-cjk-sans
          ubuntu_font_family
        ];
    };
}
