{ config , pkgs , ... }:

{
    #environment.systemPackages = with pkgs; [
    #    displaylink
    #];

    services.xserver.videoDrivers = [
        "modesetting" "displaylink"
    ];

    environment.sessionVariables = {
        "KWIN_FORCE_SW_CURSOR" = "1";
    };
}
