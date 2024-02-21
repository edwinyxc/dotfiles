{ config , pkgs , ... }:

{

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma6.enable = true;

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


}
