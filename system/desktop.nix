{ config , pkgs , ... }:

{

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  imports = [ ./kde.nix ];

  # fcitx 5
  #i18n.inputMethod = {
  #  enabled = "fcitx5";
  #  fcitx5.addons = with pkgs; [
  #      fcitx5-mozc
  #      fcitx5-gtk
  #  ];
  #};

  environment.systemPackages = with pkgs; [
    #crow-translate # 
      #Desktop apps goes here
      google-chrome
      libreoffice-qt
      mission-center
      neovide
      p3x-onenote
      joplin-desktop
      motrix
      onedrivegui
      zotero
  ];

  # OneDrive
  services.onedrive.enable = true;

}
