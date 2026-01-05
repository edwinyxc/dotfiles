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

            dse-typewriter-font # TODO font-face name?
            font-awesome
            powerline-fonts

            # A sans-serif font metric-compatible with Microsoft Calibri 
            carlito 
            # A serif font metric-compatible with Microsoft Cambria
            caladea

            vista-fonts
            helvetica-neue-lt-std

            # "free" corefonts
            liberation_ttf

            noto-fonts
            noto-fonts-cjk-serif
            noto-fonts-cjk-sans

            ubuntu-classic
            jetbrains-mono
            nerd-fonts.blex-mono
            nerd-fonts.jetbrains-mono
      ];
    };
}
