MEMORY := 8192
TESTBED := "$(shell readlink ./result)#testbed"
BUILDFLAGS :=

build: clean
	./bootstrap.nix

# VM
build-vm: build 
	nixos-rebuild build-vm --flake $(TESTBED)

start-vm: build-vm
	./result/bin/run-*-vm -m $(MEMORY)

# SYSTEM
build-system-upgrade: build
	nixos-rebuild build $(BUILDFLAGS) --upgrade --flake "$(shelll readlink ./result)#$(ATTR)"

build-system: build
	nixos-rebuild build $(BUILDFLAGS) --flake "$(shelll readlink ./result)#$(ATTR)"

switch-to-system: build
	nixos-rebuild build $(BUILDFLAGS) --flake "$(shelll readlink ./result)#$(ATTR)"

# OTHER
.PHONY: clean
clean:
	@rm -f result 
