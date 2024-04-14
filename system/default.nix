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

    #shell = pkgs.;

    extraGroups = [ "networkmanager" "wheel" "video"];
    packages = with pkgs; [
        #zsh
    ];

    # authorizedKeys
    openssh.authorizedKeys.keys = [
        ''
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCxZwHTxuK8D/LpBnrYWPMEJ9NST936EtylJPAcvxsSM9ldCPIzyBpQWw52gZFl2hDa4VebKRh4qFJsOzcppbcEkhmx+CYfjQX5EjMV20XuvLyN8ATyxSAV+pWcv3XBaOM0GTpClWypaoRS8RDBNmN0LfvD9R7VezxUf6kJuDiKPltR1uCmUkTauVs7aN/vPzbDKU41+01JChP3p5qXT3SR8m1MXkNIK8YeGGCNdOZpPlIyrf10TS2wxPRztaAhKdyBfyoy4n+kxg7LFidqIpddeC/YN1LfDPV8Z3Hr73uRiO8C57kNbuH7k7ZXY49DZQndC4tCebjxaQmH5WBKDwOT yue@yue-AB350M-HD3
        ''
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
      neovim tmux 
      git wget curl unzip ouch
      usbutils pciutils nettools 
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

  #programs.zsh.enable = true;

  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  services.openssh = {
    enable = true;
    ports = [22];
    settings.PasswordAuthentication = false;
  };

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


  #samba??? TODO move to a separate file
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user 
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.1. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = ed
        map to guest = bad user
      '';
      shares = {
        public = {
          path = "/home/ed/Public";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          #"force user" = "ed";
          #"force group" = "groupname";
        };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

}
