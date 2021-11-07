-- IMPORTS
import XMonad
import XMonad.Config.Desktop
import qualified XMonad.StackSet as W

--- data
import Data.Char (isSpace)
import Data.List
import Data.Monoid
import Data.Maybe (isJust, fromJust)
import Data.Ratio ((%)) 
import qualified Data.Map        as M

-- system
--
import System.IO (hPutStrLn) -- for xmobar
import System.Exit
import System.Directory

-- util
import XMonad.Util.Run (safeSpawn, unsafeSpawn, runInTerm, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeysP, additionalMouseBindings)
import XMonad.Util.NamedScratchpad
import XMonad.Util.NamedWindows
import XMonad.Util.WorkspaceCompare

-- hooks
--
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, docksStartupHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog, doFullFloat, doCenterFloat, doRectFloat)
import XMonad.Hooks.Place (placeHook, withGaps)
import XMonad.Hooks.UrgencyHook

-- actions
import XMonad.Actions.CycleWS (moveTo, WSType(NonEmptyWS), Direction1D(Next, Prev))
import XMonad.Actions.CopyWindow
import XMonad.Actions.UpdatePointer
import XMonad.Actions.MouseResize
import XMonad.Actions.GridSelect
import XMonad.Actions.WithAll(sinkAll, killAll)


-- layout
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed (renamed, Rename(Replace))
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.GridVariants
import XMonad.Layout.ResizableTile
import XMonad.Layout.BinarySpacePartition
import XMonad.Layout.Gaps
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

import Graphics.X11.ExtraTypes.XF86

--
--- IMPORTS for Polybar
--
import qualified Codec.Binary.UTF8.String as UTF8
import qualified DBus as D
import qualified DBus.Client as D

myFont :: String
myFont = "xft:Cousine Nerd Font Mono:regular:size=11:antialias=true:hinting=true"
myModMask       = mod4Mask

myTerminal = "alacritty"
appLauncher = "rofi -modi drun,ssh,window -show drun -show-icons"
screenLocker = "multilockscreen -1 dim"
playerctl c = "playperctl --player=spotify,%any " <> c

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True

myClickJustFocuses :: Bool
myClickJustFocuses = False

myBorderWidth   = 2

myNormalBorderColor  = "#34495e"
myFocusedBorderColor = "#9d9d9d"
myppCurrent = "#cb4b16"
myppVisible = "#cb4b16"
myppHidden = "#268bd2"
myppHiddenNoWindows = "#93A1A1"
myppTitle = "#FDF6E3"
myppUrgent = "#DC322F"

myScratchPads :: [NamedScratchpad]
myScratchPads = [
		  NS "terminal" spawnTerm findTerm manageTerm
		]
  where 
    spawnTerm = myTerminal ++ " -t scratchpad"
    findTerm  = title =? "scratchpad"
    manageTerm = customFloating $ W.RationalRect l t w h
      where 
        h = 0.9
	w = 0.9
	t = 0.95 - h
	l = 0.95 - w
    

myWorkspaces    = ["1","2","3","4","5"]
myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x, y)

clickable ws = "<action=xdotool key super++"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup  ws myWorkspaceIndices

windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "dmenu_run")

    -- launch dmenu
    , ((modm .|. controlMask, xK_p     ), spawn appLauncher)

    -- lockscreen
    , ((modm .|. controlMask, xK_l     ), spawn screenLocker)

    -- launch gmrun
    , ((modm .|. shiftMask, xK_p     ), spawn "gmrun")

    -- move WS
    , ((modm .|. controlMask, xK_Left ), XMonad.Actions.CycleWS.moveTo Prev NonEmptyWS)

    , ((modm .|. controlMask, xK_Right ), XMonad.Actions.CycleWS.moveTo Next NonEmptyWS)

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((modm,               xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((modm .|. shiftMask, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((modm .|. shiftMask, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling

    , ((modm,               xK_t     ), withFocused $ windows . W.sink)
    , ((modm .|. shiftMask, xK_t     ), sinkAll)
    , ((modm,               xK_f     ), sendMessage (T.Toggle "floats"))

    -- Increment the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    -- Run xmessage with a summary of the default keybindings (useful for beginners)
    , ((modm .|. shiftMask, xK_slash ), spawn ("echo \"" ++ help ++ "\" | xmessage -file -"))

    ]
    -- Audio & brightness
    ++
    [ ((0              , xF86XK_AudioMute     ), spawn "amixer -q set Master toggle")
    , ((0              , xF86XK_AudioLowerVolume ), spawn "amixer -q set Master 5%-")
    , ((0              , xF86XK_AudioRaiseVolume ), spawn "amixer -q set Master 5%+")

    , ((0              , xF86XK_AudioPlay     ), spawn $ playerctl "play-pause"     )
    , ((0              , xF86XK_AudioStop     ), spawn $ playerctl "stop"     )
    , ((0              , xF86XK_AudioPrev     ), spawn $ playerctl "previous"     )
    , ((0              , xF86XK_AudioNext     ), spawn $ playerctl "next"     )

    , ((0              , xF86XK_MonBrightnessUp), spawn "brightnessctl set 10%+"     )
    , ((0              , xF86XK_MonBrightnessDown), spawn "brightnessctl set 10%-"     )
    ]
    ++
    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    -- , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button2), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
--

-- Makes setting the spacingRaw simpler to write. The spacingRaw module 
-- adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True


-- Define layouts
--

tall = renamed [ Replace "tall" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 12
       $ mySpacing 8
       $ ResizableTall 1 (3/100) (1/2) []

magnify = renamed [ Replace "magnify" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ magnifier
       $ limitWindows 12
       $ mySpacing 8
       $ ResizableTall 1 (3/100) (1/2) []

monocle = renamed [ Replace "monocle" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 20 Full


floats = renamed [ Replace "floats" ]
       $ smartBorders
       $ limitWindows 20 simplestFloat

grid = renamed [ Replace "grid" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 12
       $ mySpacing 8
       $ mkToggle (single MIRROR)
       $ Grid(16/10)

spirals   = renamed [ Replace "spirals" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ mySpacing' 8
       $ spiral (6/7)

threeCol = renamed [ Replace "threeCol" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 7
       $ ThreeCol 1 (3/100) (1/2)

threeRow = renamed [ Replace "threeRow" ]
       $ smartBorders
       $ windowNavigation
       $ addTabs shrinkText myTabTheme
       $ subLayout [] (smartBorders Simplest)
       $ limitWindows 7
       $ Mirror
       $ ThreeCol 1 (3/100) (1/2)

tabs = renamed [ Replace "tabs" ]
       $ tabbed shrinkText myTabTheme

tallAccordion = renamed [Replace "tallAccordion"]
	$ Accordion

wideAccordion = renamed [Replace "wideAccordion"]
	$ Mirror Accordion

myTabTheme = def { 
fontName = myFont
, activeColor = "#46d9ff"
, inactiveColor = "#313846"
, activeBorderColor = "#46d9ff"
, inactiveBorderColor = "#282c34"
, activeTextColor = "#282c34"
, inactiveTextColor = "#d0d0d0"
}

myLayoutHook = avoidStruts $ mouseResize $ windowArrange $ T.toggleLayouts floats
   $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
   myDefaultLayout = withBorder myBorderWidth tall
     ||| magnify
     ||| noBorders monocle 
     ||| floats
     ||| noBorders tabs
     ||| grid
     ||| spirals
     ||| threeCol
     ||| threeRow 
     ||| tallAccordion
     ||| wideAccordion

------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "confirm"           --> doFloat
    , className =? "file_progress"           --> doFloat
    , className =? "dialog"           --> doFloat
    , className =? "error"           --> doFloat
    , className =? "download"           --> doFloat
    , className =? "notification"           --> doFloat
    , className =? "splash"           --> doFloat
    , className =? "toobar"           --> doFloat
    , className =? "Gimp"           --> doFloat
    , className =? "Firefox" <&&> resource =? "Toolkit" --> doFloat
    , className =? "firefox" <&&> resource =? "Dialog" --> doFloat
    , isFullscreen --> doFullFloat
    , resource  =? "desktop_window" --> doIgnore ] <+> namedScratchpadManageHook myScratchPads

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
-- myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
-- myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.

-- Run xmonad with the settings you specify. No need to modify this.
--
main = do
        xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/.xmobarrc"
-- xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/.xmobarrc"
        xmonad $ ewmh def {
        manageHook         = manageDocks <+> myManageHook,
        handleEventHook    = docksEventHook <+> fullscreenEventHook,
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        clickJustFocuses   = myClickJustFocuses,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayoutHook,
        startupHook        = myStartupHook,
        logHook            = dynamicLogWithPP $ namedScratchpadFilterOutWorkspacePP $ xmobarPP
	{ ppOutput = \x -> hPutStrLn xmproc0 x 
	, ppCurrent = xmobarColor myppCurrent "" . wrap "[" "]" -- Current workspace in xmobar
	, ppVisible = xmobarColor myppVisible"" -- Visible but not Current
	, ppHidden = xmobarColor myppHidden "" . wrap "+" "" -- Hidden workspaces
	, ppHiddenNoWindows = xmobarColor myppHiddenNoWindows ""-- Hidden workspaces (No windows)
	, ppTitle = xmobarColor myppTitle "" . shorten 80 -- Title of active windows in xmobar
	, ppSep = "<fc=#586e75> | </fc>"
	-- , ppUrgent = xmobarColor myppUrgent "" . wrap "!" "!" -- Urgent workspace
	, ppExtras = [windowCount]
	, ppOrder = \(ws:l:t:ex) -> [ws,l]++ex++[t]
	} 
    }

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",
    "",
    "-- launching and killing programs",
    "mod-Shift-Enter  Launch xterminal",
    "mod-p            Launch dmenu",
    "mod-Shift-p      Launch gmrun",
    "mod-Shift-c      Close/kill the focused window",
    "mod-Space        Rotate through the available layout algorithms",
    "mod-Shift-Space  Reset the layouts on the current workSpace to default",
    "mod-n            Resize/refresh viewed windows to the correct size",
    "",
    "-- move focus up or down the window stack",
    "mod-Tab        Move focus to the next window",
    "mod-Shift-Tab  Move focus to the previous window",
    "mod-j          Move focus to the next window",
    "mod-k          Move focus to the previous window",
    "mod-m          Move focus to the master window",
    "",
    "-- modifying the window order",
    "mod-Return   Swap the focused window and the master window",
    "mod-Shift-j  Swap the focused window with the next window",
    "mod-Shift-k  Swap the focused window with the previous window",
    "",
    "-- resizing the master/slave ratio",
    "mod-h  Shrink the master area",
    "mod-l  Expand the master area",
    "",
    "-- floating layer support",
    "mod-t  Push window back into tiling; unfloat and re-tile it",
    "",
    "-- increase or decrease number of windows in the master area",
    "mod-comma  (mod-,)   Increment the number of windows in the master area",
    "mod-period (mod-.)   Deincrement the number of windows in the master area",
    "",
    "-- quit, or restart",
    "mod-Shift-q  Quit xmonad",
    "mod-q        Restart xmonad",
    "mod-[1..9]   Switch to workSpace N",
    "",
    "-- Workspaces & screens",
    "mod-Shift-[1..9]   Move client to workspace N",
    "mod-{w,e,r}        Switch to physical/Xinerama screens 1, 2, or 3",
    "mod-Shift-{w,e,r}  Move client to screen 1, 2, or 3",
    "",
    "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
