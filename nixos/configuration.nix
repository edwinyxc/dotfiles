# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{lib, config, pkgs, ... }:

with lib;
{
  imports =
    [ 
      # wsl import see - https://github.com/nix-community/NixOS-WSL
      # include NixOS-WSL modules
      <nixos-wsl/modules>
      # Fonts
      ./system/fonts.nix
      # Vim / Neovim
      ./system/vim.nix
      # Tmux
      ./system/tmux.nix
    ];

	wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "ed";
    startMenuLaunchers = true;
         
    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };


  environment.variables = {
    EDITOR = "vim";
    NIXPKGS_ALLOW_UNFREE = "1";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ed = {
    isNormalUser = true;
    description = "Edwin";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "video"];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
      zsh
      neovim
      tmux
      git
      wget curl
      unzip
  ];


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
  };


  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

  system.stateVersion = "23.05"; # Did you read the comment? 
    
  nix = {
    settings.auto-optimise-store = true;
    gc = {
        automatic = true;
        dates     = "weekly";
        options   = "--delete-older-than 7d";
    };

 # Enable nix flakes, etc.
    extraOptions = ''
        keep-outputs = true
        keep-derivations = true

        experimental-features = nix-command flakes
    '';
    settings.trusted-users = [ "root" "ed" ];
  };

  environment.shellInit = ''
  export ZDOTDIR=$HOME/.config/zsh
  '';

  programs.zsh = {
      enable = true;
      shellAliases = { vim = "nvim"; };
      enableCompletion = true;
      autosuggestions.enable = true;
  };

  environment.pathsToLink = [ "/share/zsh" ];
    
}
