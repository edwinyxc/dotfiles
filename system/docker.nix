{ config, pkgs, ... }:
{
    virtualisation.docker.enable = true;
    virtualisation.libvirtd.enable = true;

    environment.systemPackages = with pkgs; [
        virt-manager
        dnsmasq
        flex
        bison
    ];

    users.users.ed.extraGroups = [ "docker" "libvirtd" "kvm" ];

    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "ed" ];
}
