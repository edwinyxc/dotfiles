{ config , pkgs , ... }:

{

  imports = [
      # Vim 
      ./vim.nix
      # Tmux
      ./tmux.nix
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

  services.xserver.xkbOptions = "ctrl:nocaps";
  console.useXkbConfig = true;
  #console = {
  #  useXkbConfig = true;
  #  earlySetup = true;
  #  packages = with pkgs; [terminus_font];
  #  font = "ter-u28n";
  #};


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      zsh neovim tmux 
      git wget curl unzip ouch
      usbutils pciutils nettools toybox
      bat gnumake clang meson ninja
      man-pages tree unzip zip
      neofetch tealdeer gitui gitg
      nodePackages.npm yarn rustup 
  ];

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


  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
