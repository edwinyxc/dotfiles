{ config, pkgs, ... }:

let 
	commonPkgs = with pkgs; [
		# arandr
		exa
		tldr
		tree
		alacritty
		dconf
		neofetch
		thunderbird
		gnome.adwaita-icon-theme
	];

	textPkgs = with pkgs; [
		tmux
	];

	miscPkgs = with pkgs; [
		chromium
		unigine-valley 
	];
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "ed";
  home.homeDirectory = "/home/ed";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  home.sessionVariables = {
	  DISPLAY = ":0";
	  EDITOR = "nvim";
	  #MOZ_ENABLE_WAYLAND = 1;
  };

  nixpkgs.config.allowUnfree = true;

  # disallow HM to create its own keyboard map aka stxkbmap
  home.keyboard = null;

  xdg.enable = true;
  
  imports = [
	./home/xmonad.nix
	./home/neovim.nix
	#./home/rofi.nix
  ];

  home.packages = with pkgs; commonPkgs ++ textPkgs ++ miscPkgs;

  # firefox-wayland workaround

 # programs.firefox = {
 #         enable = true;
 #         package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
 #       	  forceWayland = true;
 #       	  extraPolicies = {
 #       		  ExtensionSettings = {};
 #       	  };
 #         };
 # };

  home.file =  {
    ".config/alacritty/alacritty.yaml".text = ''
      env:
        TERM: xterm-256color
    '';
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";
  
  # notifications about home-manager news
  news.display = "silent";

  programs = {};

}
