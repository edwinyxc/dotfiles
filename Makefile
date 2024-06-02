TARGET_FRAMEWORK = FW-i11
TARGET_WSL = wsl
TARGET_DEFAULT= $(TARGET_FRAMEWORK)

.PHONY: all
all: 
	sudo nixos-rebuild switch --flake .#$(TARGET_DEFAULT)--show-trace  --upgrade

