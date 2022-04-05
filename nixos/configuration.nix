# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ config, pkgs, ... }:

let 
customFonts = pkgs.nerdfonts.override {
	fonts = [
		"FiraCode"
		"DroidSansMono"
		"Cousine"
		"Terminus"
		"JetBrainsMono"
	];

};
	#myfonts =I 
in
{
	imports =
		[ # Include the results of the hardware scan.
		./hardware-configuration.nix
		#./wm-xmonad.nix
		#./wm-gnome.nix
		#./wm-kde.nix
		./wm-sway.nix
		];



# Use the systemd-boot EFI boot loader.
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;
	boot.kernelPackages = pkgs.linuxPackages_latest;
	boot.kernelParams = ["mem_sleep_default=deep" "acpi_osi=\"Windows 2020\""];

	nixpkgs.config.allowUnfree = true;

# Systemd config
#

systemd.extraConfig = ''
  DefaultTimeoutStopSec=20s
  RebootWatchdogSec=0
'';


	networking.hostName = "farm-nixos"; # Define your hostname.
# networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

# The global useDHCP flag is deprecated, therefore explicitly set to false here.
# Per-interface useDHCP will be mandatory in the future, so this generated config
# replicates the default behaviour.
	networking.useDHCP = false;
	networking.interfaces.wlp170s0.useDHCP = true;
# NetworkManager
	networking.networkmanager.enable = true;

# Configure network proxy if necessary
# networking.proxy.default = "http://user:password@proxy:port/";
# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";
# Set your time zone.
	time.timeZone = "Australia/Sydney";
	console = {
		#font = "Lat2-Terminus16";
		font = "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
		#keyMap = "us";
	};
	console.useXkbConfig = true;
	services.xserver.xkbOptions = "ctrl:nocaps";

	#services.xserver.dpi =180;

# Enable the X11 windowing system.
	#services.xserver.enable = true;

# Enable the GNOME Desktop Environment.
	#services.xserver.displayManager.gdm.enable = true;
	#services.xserver.desktopManager.gnome.enable = true;


# Configure keymap in X11
# services.xserver.layout = "us";
# services.xserver.xkbOptions = "eurosign:e";

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# fingerprint support
	services.fprintd.enable = true;

# Enable sound.
 sound.enable = true;
 hardware.pulseaudio.enable = true;
 hardware.video.hidpi.enable = true;

# 

# Enable touchpad support (enabled default in most desktopManager).
	#services.xserver.libinput.enable = true; # enabled elsewhere


# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.ed= {
		isNormalUser = true;
		extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
	};

# List packages installed in system profile. To search, run:
# $ nix search wget
	environment.systemPackages = with pkgs; [
		vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
 		alacritty
		wget curl
		firefox
		gitAndTools.gitFull
		iptables nmap tcpdump
		unzip
	];

	# Some programs need SUID wrappers, can be configured further or are
	# started in user sessions.
	#programs.mtr.enable = true;
	programs.gnupg.agent = {
		enable = true;
		enableSSHSupport = true;
	};

# List services that you want to enable:

	services = {
		# Enable the OpenSSH daemon.
		openssh = {
			enable = true;
			#allowsSFTP = true;
		};

		# Enable the sshd
		sshd.enable = true;

	};

	fonts.fonts = with pkgs; [
		customFonts
		font-awesome-ttf
		corefonts
		inconsolata
		wqy_microhei
		wqy_zenhei
	];

# Open ports in the firewall.
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];
# Or disable the firewall altogether.
# networking.firewall.enable = false;
#

	#nixpkgs.config.allowUnfree = true;

	nix = {
		# Automate `nix-store --optimize`
		autoOptimiseStore = true;

		# Automate garbage collection
		gc = {
			automatic = true;
			dates     = "weekly";
			options   = "--delete-older-than 7d";
		};

# avoid unwanted garbage collection when using nix-direnv
		extraOptions = ''
			keep-outputs = true
			keep-derivations = true
			# Make ready for flake
	  		experimental-features = nix-command flakes
		'';
			trustedUsers = [ "root" "ed"];
	};


	# hardware acceleration video playback
	nixpkgs.config.packageOverrides = pkgs: {
		vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
	};

	hardware.opengl = {
		enable = true;
		extraPackages = with pkgs; [
			intel-media-driver # LIBVA_DRIVER_NAME=iHD
			vaapiIntel
			vaapiVdpau
			libvdpau-va-gl
		];
	};

	# power auto-cpufreq
	# services.auto-cpufreq.enable = true; 
	

	# tlp
	#
	services.tlp = {
		#enable = true;
		enable = false;
		settings = {
			CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
			PCIE_ASPM_ON_BAT = "powersupersave";
			CPU_SCALING_GOVERNOR_ON_ACT = "performance";
		};

	};

	# powertop: run powertop --auto-tune on startup
	
	powerManagement.powertop.enable = true;

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "21.11"; # Did you read the comment?

}

