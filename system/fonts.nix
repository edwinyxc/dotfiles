{ inputs, pkgs, lib, config, ...}:
let 
	dse-typewriter-font = pkgs.stdenvNoCC.mkDerivation {
		name = "dse-typewriter-font";
		dontConfigure = true;
		src = inputs.dse-typewriter-font;
		installPhase = ''
mkdir -p $out/share/fonts/truetype
cp $src/ttf/*.ttf $out/share/fonts/truetype/
		'';
		meta = {
			description = "des-typewriter-font has the best taste!"; 
			homepage = "https://github.com/dse/dse-typewriter-font";
			license  = lib.licenses.ofl;
		};
	};
in
{
    fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        packages = with pkgs; [
          # corefonts # Microsoft free fonts i.e. New Courier

	  dse-typewriter-font # TODO font-face name?
          font-awesome
          powerline-fonts

        # A sans-serif font metric-compatible with Microsoft Calibri 
        carlito 
        # A serif font metric-compatible with Microsoft Cambria
        caladea

        vistafonts

          helvetica-neue-lt-std
          
          # "free" corefonts
          liberation_ttf
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
