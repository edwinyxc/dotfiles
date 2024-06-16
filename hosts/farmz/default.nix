# Framework intel 11th Gen Framework
{ config, pkgs, ...}:
let 

power_now = pkgs.writeShellScriptBin "power_now" ''
#!/usr/bin/env bash
'cat' /sys/class/power_supply/BAT1/current_now /sys/class/power_supply/BAT1/voltage_now | xargs | awk '{printf "%.2f W", $1*$2/1e12}'
'';

cpu_turbo_boost_enable = pkgs.writeShellScriptBin  "cpu_turbo_boost_enable" (
		builtins.readFile ./cpu_turbo_boost_enable.sh
);

in
{
	imports = [
		./hardware-configuration.nix
		./nfs.nix
	]; 

	# Bootloader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	networking.hostName = "farmz"; # Define your hostname.
	networking.hostId = "cf1b76a6";

	# Enable networking
	networking.networkmanager.enable = true;

	console.useXkbConfig = true;

	#services.xserver.xkb.options = "ctrl:nocaps";

	# Enable CUPS to print documents.
	services.printing.enable = true;

	hardware.bluetooth = {
		enable = true;
		powerOnBoot = false;
		settings.General.Experimental = true; # for gnome-bluetooth percentage
	};

	# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		jack.enable = true;

	};

	environment.systemPackages = with pkgs; [
		powertop
		htop
		parted
		power_now

		msr-tools # required by the following
		cpu_turbo_boost_enable
	];

	systemd.services.fkDell = {
		enable = true;
		wantedBy = [ "multi-user.target" ];
		path = with pkgs; [
			bash
			msr-tools
			which
			gawk
			findutils
			coreutils-full # cat and such
			cpu_turbo_boost_enable
		];
		description = "unlock CPU turbo to avoid being stuck at 800MHz";
		serviceConfig = {
			Type = "oneshot";
			ExecStart = "${pkgs.bash}/bin/bash cpu_turbo_boost_enable";
		};
	};

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.11"; # Did you read the comment? 
}
