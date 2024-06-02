TARGET_FRAMEWORK = FW-i11
TARGET_WSL = wsl
TARGET_DEFAULT= $(TARGET_FRAMEWORK)

.PHONY: all
all: 
	sudo nixos-rebuild switch --flake .#$(TARGET_DEFAULT) --show-trace  --upgrade

framework:
	sudo nixos-rebuild switch --flake .#$(TARGET_FRAMEWORK) --show-trace  --upgrade

wsl:
	sudo nixos-rebuild switch --flake .#$(TARGET_WSL) --show-trace  --upgrade
