DEFAULT=framework
all: 
	$(framework)

framework: 
	sudo nixos-rebuild switch --flake .#FW-i11 --show-trace  --upgrade

wsl: 
	sudo nixos-rebuild switch --flake .#wsl --show-trace  --upgrade

