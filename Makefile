TARGET_FRAMEWORK = FW-i11
TARGET_WSL = wsl
TARGET_FARMZ = farmz
TARGET_DEFAULT = $(TARGET_FRAMEWORK)

.PHONY: all test framework wsl

all: 
	sudo nixos-rebuild switch --flake .#$(TARGET_DEFAULT)  --upgrade

framework:
	sudo nixos-rebuild switch --flake .#$(TARGET_FRAMEWORK)  --upgrade

wsl:
	sudo nixos-rebuild switch --flake .#$(TARGET_WSL)  --upgrade

farmz:
	sudo nixos-rebuild switch --flake .#$(TARGET_FARMZ)  --upgrade

clean:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old

