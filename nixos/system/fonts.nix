{ pkgs, lib, config, ...}:
{
    fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        fonts = with pkgs; [
          corefonts # Microsoft free fonts
          font-awesome
          powerline-fonts
          source-han-sans-simplified-chinese
          source-han-sans-traditional-chinese
          ubuntu_font_family
          wqy_microhei
          wqy_zenhei
        ];
    };
}
