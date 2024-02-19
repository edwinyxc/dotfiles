{ config , pkgs , ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

  #  deprecated in 6 
  #services.xserver.displayManager.defaultSession = "plasmawayland";

  services.xserver.displayManager.defaultSession = "plasma";

  services.xserver.libinput.touchpad.disableWhileTyping = true;
  services.xserver.libinput.touchpad.naturalScrolling  = true;

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

  # vim friendly pdf reader
  # programs.zathura.enable = true;

  # OneDrive
  services.onedrive.enable = true;

}
