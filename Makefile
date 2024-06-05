TARGET_FRAMEWORK = FW-i11
TARGET_WSL = wsl
TARGET_DEFAULT= $(TARGET_FRAMEWORK)

.PHONY: all test framework wsl

all: 
	sudo nixos-rebuild switch --flake .#$(TARGET_DEFAULT)  --upgrade

framework:
	sudo nixos-rebuild switch --flake .#$(TARGET_FRAMEWORK)  --upgrade

wsl:
	sudo nixos-rebuild switch --flake .#$(TARGET_WSL)  --upgrade

clean:
	sudo nix store gc --debug
	sudo nix-collect-garbage --delete-old

