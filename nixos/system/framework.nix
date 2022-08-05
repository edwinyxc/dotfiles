{ config, lib, pkgs, ...}: 

{
  environment.variables = {
     VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  boot.supportedFilesystems = [ "ntfs" ];

  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    libvdpau-va-gl
    intel-media-driver
    intel-compute-runtime
  ];

  # Gnome 40 introduced a new way of managing power, without tlp.
  # However, these 2 services clash when enabled simultaneously.
  # https://github.com/NixOS/nixos-hardware/issues/260

  services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
          PCIE_ASPM_ON_BAT = "powersupersave";
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          START_CHARGE_THRESH_BAT1 = 90;
          STOP_CHARGE_THRESH_BAT1 = 97;
          RUNTIME_PM_ON_BAT = "auto";
      };
  };

  # install powertop first
  # powertop --auto-tune

  #powerManagement.powertop.enable = true; 
  

  services.fstrim.enable = lib.mkDefault true;

  boot.kernelParams = [
    # For Power consumption
    # https://kvark.github.io/linux/framework/2021/10/17/framework-nixos.html
    "mem_sleep_default=deep"

    # For Power consumption
    # https://community.frame.work/t/linux-battery-life-tuning/6665/156
    "nvme.noacpi=1"
  ];
  
  # Requires at least 5.16 for working wi-fi and bluetooth.
  # https://community.frame.work/t/using-the-ax210-with-linux-on-the-framework-laptop/1844/89
  # boot.kernelPackages = lib.mkIf (lib.versionOlder pkgs.linux.version "5.16") (lib.mkDefault pkgs.linuxPackages_latest);
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Fix TRRS headphones missing a mic
  # https://community.frame.work/t/headset-microphone-on-linux/12387/3
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-headset-multi
  '';

  # For fingerprint support
  #services.fprintd.enable = lib.mkDefault true;

  # Fix headphone noise when on powersave
  # https://community.frame.work/t/headphone-jack-intermittent-noise/5246/55
  services.udev.extraRules = ''
    SUBSYSTEM=="pci", ATTR{vendor}=="0x8086", ATTR{device}=="0xa0e0", ATTR{power/control}="on"
  '';

  # Mis-detected by nixos-generate-config
  # https://github.com/NixOS/nixpkgs/issues/171093
  # https://wiki.archlinux.org/title/Framework_Laptop#Changing_the_brightness_of_the_monitor_does_not_work
  hardware.acpilight.enable = lib.mkDefault true;


}
