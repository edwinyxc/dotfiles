{ config, pkgs, ... }:
{

    environment.systemPackages = with pkgs; [
    ];

    programs.adb.enable = true;

    users.users.ed.extraGroups = ["adbusers"];
}
