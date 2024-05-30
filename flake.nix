{
description = "Edwin's nixos flake";

nixConfig = {
	experimental-features = ["nix-command" "flakes"];
};

inputs = {
# Offical NixOS pkg source
nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#Deprecated 
# kde2nix.url = "github:nix-community/kde2nix";

# NixOS hardware 
nixos-hardware.url = "github:NixOS/nixos-hardware/master";

# NixOS-WSL
NixOS-WSL = {
	url = "github:nix-community/NixOS-WSL";
	inputs.nixpkgs.follows = "nixpkgs";
};

# BEGIN Vim plugins
# which are not found in nixpkgs:
vimPlugins_toggle-lsp-diagnostics-nvim = {
	url = "github:WhoIsSethDaniel/toggle-lsp-diagnostics.nvim";
	flake = false;
};

vimPlugins_telescope-bibtex-nvim = {
	url = "github:nvim-telescope/telescope-bibtex.nvim";
	flake = false; 
};

#https://github.com/hedyhli/outline.nvim
vimPlugins_outline-nvim = {
	url = "github:hedyhli/outline.nvim";
	flake = false;
};

#https://github.com/hedyhli/outline.nvim
vimPlugins_fzf-mru-vim = {
	url = "github:pbogut/fzf-mru.vim";
	flake = false;
};
# END Vim plugins

# hyprland
#hyprland.url = 

# add ags
ags.url = "github:Aylur/ags";
astal.url = "github:Aylur/astal";

#home-manager
home-manager = {
	url = "github:nix-community/home-manager";
	# keep home-manager consistent with the current flake 
	# on `inputs.nixpkgs`
	inputs.nixpkgs.follows = "nixpkgs";
};

firefox-gnome-theme = {
    url = "github:rafaelmardojai/firefox-gnome-theme";
    flake = false;
};
};

outputs = {
	self, nixpkgs, home-manager, ...
} @inputs: let 
username = "ed";
overlay = import ./overlays {inherit inputs;};
nixosModules = []; #TODO
homeModeuls = []; #TODO
in { nixosConfigurations = {

"wsl" = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = { inherit inputs; };
	modules = [
inputs.NixOS-WSL.nixosModules.wsl
./hosts/wsl
./system
#home
home-manager.nixosModules.home-manager {
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.extraSpecialArgs = {
		inherit inputs;
		_imports = [ 
		];   
	};
	home-manager.users.${username} = import ./home;
	#home-manager.backupFileExtension = "backup";
}
	];
};

"FW-i11" = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	specialArgs = { inherit inputs; };
	modules = [
# (import ./overlays)
# Framework i11 -- main config 
./hosts/FW-i11
./system
./system/fonts.nix

# Desktop
./system/desktop.nix
./system/misc.nix

# Fonts
./system/fonts.nix

# Firefox
./system/firefox.nix

# framework hardware upstream tweaks
inputs.nixos-hardware.nixosModules.framework-11th-gen-intel

#KDE 6
#inputs.kde2nix.nixosModules.plasma6

#home-manager
home-manager.nixosModules.home-manager {
	home-manager.useGlobalPkgs = true;
	home-manager.useUserPackages = true;
	home-manager.extraSpecialArgs = {
		inherit inputs;
		_imports = [
./home/desktop
./home/desktop/hyprland.nix
./home/desktop/firefox-gnome-theme.nix
#./home/
		];   
	};
	home-manager.users.${username} = import ./home;
	home-manager.backupFileExtension = "backup";
    }
	];
};
};
};
}
