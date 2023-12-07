{ pkgs, lib, config, ...}:
{
    fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        packages = with pkgs; [
          corefonts # Microsoft free fonts i.e. New Courier
          font-awesome
          powerline-fonts

          noto-fonts
          noto-fonts-cjk-serif
          noto-fonts-cjk-sans
          ubuntu_font_family
          jetbrains-mono
          #
          (nerdfonts.override {
               fonts = [
                   # font family - 'Blex Mono Nerd Font Mono'
                   "IBMPlexMono"
                   "JetBrainsMono"
               ]; 
           }) 
        ];
    };
}
