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
}
