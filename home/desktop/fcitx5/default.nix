{ inputs, lib, pkgs, ... }:
{
	home.packages = with pkgs; [
		fcitx5
	];

	# fcitx5
	i18n.inputMethod = {
		enabled = "fcitx5";
		fcitx5.addons = with pkgs; [
			fcitx5-rime
			fcitx5-mozc
			fcitx5-gtk
			# needed enable rime using configtool after installed
			fcitx5-configtool
			fcitx5-chinese-addons
		];
	};

	home.file = {
		".config/fcitx5".source = ./_config;
		".local/share/fcitx5" = {
			source = ./data;
			recursive = true;
		};
	};

}
