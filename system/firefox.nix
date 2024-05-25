{ config , pkgs , lib, ... }: 
{

environment.systemPackages = with pkgs; [ 
    firefoxpwa 
];

  # firefox
programs.firefox = {

    enable = true;
    autoConfig = ''

pref("apz.overscroll.enabled",                                     true);//NSS    [120]
pref("general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS",   12);//NSS    [120]
pref("general.smoothScroll.msdPhysics.enabled",                    true);//NSS  [false]
pref("general.smoothScroll.msdPhysics.motionBeginSpringConstant",   200);//NSS   [1250]
pref("general.smoothScroll.msdPhysics.regularSpringConstant",       250);//NSS   [1000]
pref("general.smoothScroll.msdPhysics.slowdownMinDeltaMS",           25);//NSS     [12]
pref("general.smoothScroll.msdPhysics.slowdownMinDeltaRatio",     "2.0");//NSS    [1.3]
pref("general.smoothScroll.msdPhysics.slowdownSpringConstant",      250);//NSS   [2000]
pref("general.smoothScroll.currentVelocityWeighting",             "1.0");//NSS ["0.25"]
pref("general.smoothScroll.stopDecelerationWeighting",            "1.0");//NSS  ["0.4"]

/// adjust multiply factor for mousewheel - or set to false if scrolling is way too fast  
pref("mousewheel.system_scroll_override.horizontal.factor",         50);//NSS    [200]
pref("mousewheel.system_scroll_override.vertical.factor",           50);//NSS    [200]
pref("mousewheel.system_scroll_override_on_root_content.enabled",  true);//NSS   [true]
pref("mousewheel.system_scroll_override.enabled",                  true);//NSS   [true]

/// adjust pixels at a time count for mousewheel - cant do more than a page at once if <100
pref("mousewheel.default.delta_multiplier_x",                       35);//NSS    [100]
pref("mousewheel.default.delta_multiplier_y",                       35);//NSS    [100]
pref("mousewheel.default.delta_multiplier_z",                       35);//NSS    [100]

///  this preset will reset couple extra variables for consistency
pref("apz.allow_zooming",                                          true);//NSS   [true]
pref("apz.force_disable_desktop_zooming_scrollbars",              false);//NSS  [false]
pref("apz.paint_skipping.enabled",                                 true);//NSS   [true]
pref("apz.windows.use_direct_manipulation",                        true);//NSS   [true]
pref("dom.event.wheel-deltaMode-lines.always-disabled",           false);//NSS  [false]
pref("general.smoothScroll.durationToIntervalRatio",                200);//NSS    [200]
pref("general.smoothScroll.lines.durationMaxMS",                    150);//NSS    [150]
pref("general.smoothScroll.lines.durationMinMS",                    150);//NSS    [150]
pref("general.smoothScroll.other.durationMaxMS",                    150);//NSS    [150]
pref("general.smoothScroll.other.durationMinMS",                    150);//NSS    [150]
pref("general.smoothScroll.pages.durationMaxMS",                    150);//NSS    [150]
pref("general.smoothScroll.pages.durationMinMS",                    150);//NSS    [150]
pref("general.smoothScroll.pixels.durationMaxMS",                   150);//NSS    [150]
pref("general.smoothScroll.pixels.durationMinMS",                   150);//NSS    [150]
pref("general.smoothScroll.scrollbars.durationMaxMS",               150);//NSS    [150]
pref("general.smoothScroll.scrollbars.durationMinMS",               150);//NSS    [150]
pref("general.smoothScroll.mouseWheel.durationMaxMS",               200);//NSS    [200]
pref("general.smoothScroll.mouseWheel.durationMinMS",                50);//NSS     [50]
pref("layers.async-pan-zoom.enabled",                              true);//NSS   [true]
pref("layout.css.scroll-behavior.spring-constant",                "250");//NSS    [250]
pref("mousewheel.transaction.timeout",                             1500);//NSS   [1500]
pref("mousewheel.acceleration.factor",                               10);//NSS     [10]
pref("mousewheel.acceleration.start",                                -1);//NSS     [-1]
pref("mousewheel.min_line_scroll_amount",                             5);//NSS      [5]
pref("toolkit.scrollbox.horizontalScrollDistance",                    5);//NSS      [5]
pref("toolkit.scrollbox.verticalScrollDistance",                      3);//NSS      [3]
///
pref("browser.compactmode.show",                                   true);
    '';

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/by-name/fi/firefoxpwa/package.nix#L123
    nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
  };

#
#/// better ssd life -- this is removed as will cause UB when using Microsoft SSO/OAuth agent.
#pref("browser.cache.disk.enable",                                 false);
#pref("browser.cache.memory.enable",                                true);

#

environment.sessionVariables = {
    MOZ_USE_XINPUT2 = "1";
};


##End of firefox
}
