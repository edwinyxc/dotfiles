{ config , pkgs , ... }:

{

  imports = [
      # Fonts
      ./fonts.nix
      # Vim 
      ./vim.nix
      # Tmux
      ./tmux.nix
      
      # Sway wm WIP ...
      #./system/wm-sway.nix

      # Gnome
      #./wm-gnome.nix

      # KDE
      ./kde.nix

      # Firefox
      ./firefox.nix

      # Docker & Virtualisation
      #./system/docker.nix

      # Android -ADB & JAVA
      #./system/android.nix

      # NPM 
      # ./system/nodejs.nix
      ./misc.nix
  ];

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  environment.variables = {
    EDITOR = "vim";
   # MOZ_ENABLE_WAYLAND = "1";
   # MOZ_USE_XINPUT2 = "1";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ed = {
    isNormalUser = true;
    description = "Edwin";

    shell = pkgs.zsh;

    extraGroups = [ "networkmanager" "wheel" "video"];
    packages = with pkgs; [
        zsh
    ];
  };


  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  console.useXkbConfig = true;
  #console = {
  #  useXkbConfig = true;
  #  earlySetup = true;
  #  packages = with pkgs; [terminus_font];
  #  font = "ter-u28n";
  #};

  services.xserver.xkbOptions = "ctrl:nocaps";

  # Enable CUPS to print documents.
  services.printing.enable = true;

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
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      zsh
      neovim
      neovide
      tmux
      powertop
      parted
      git
      wget curl
      unzip

      usbutils
      pciutils

      nettools

      toybox
      wpa_supplicant
      
      # TODO remove
      google-chrome

      #thunderbird
      #betterbird
      libreoffice-qt
      mission-center

      #calibre #too complex yet
      #foliate

      onedrivegui
      zotero
  ];

    # Microsoft's alternatives 

  # OneDrive
  services.onedrive.enable = true;

  #services.flatpak.enable = true;
  #xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  #xdg.portal.config.common.default = "gtk";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };

  programs.zsh.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix = {
    gc = {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
    };

    extraOptions = ''
        keep-outputs = true
        keep-derivations = true
    '';

    settings = {
        auto-optimise-store = true;
        trusted-users = [ "root" "ed" ];
        experimental-features = [ "nix-command" "flakes"];
    };
  };
}
