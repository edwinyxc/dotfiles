# windows WSL 
{ pkgs, ... }: 
{
  imports = [
    #./nvidia-cuda.nix
  ];

  wsl = {
    enable = true;
    defaultUser = "ed";
  };

 # Define your hostname.
 networking.hostName = "FARMWSL";

 programs.nix-ld.enable = true;

 programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    # for python 
      pkgs.glib
      pkgs.zlib
      pkgs.libGL
      pkgs.fontconfig
      pkgs.xorg.libX11
      pkgs.libxkbcommon
      pkgs.freetype
      pkgs.dbus
    ];

    #for wsl, use regedit for the function anyway
    #console.useXkbConfig = true;

    #services.xserver.xkbOptions = "ctrl:nocaps";


# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).

system.stateVersion = "23.11"; # Did you read the comment? 
}
