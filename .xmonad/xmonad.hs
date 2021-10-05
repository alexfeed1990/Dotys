-- Variables and Imports

import XMonad
import Data.Monoid
import System.Exit
import XMonad.Util.SpawnOnce
import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import XMonad.Layout.Renamed
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.LayoutModifier(ModifiedLayout)
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import Graphics.X11.ExtraTypes.XF86

myTerminal      = "alacritty" --Terminal
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = True --Does focus follow the mouse
myClickJustFocuses :: Bool
myClickJustFocuses = False --Does click focus windows
myBorderWidth   = 2 --Border width of windows in pixels
myModMask       = mod4Mask --mod or "super" key
myWorkspaces    = ["1","2","3","4","5","6","7","8","9"] --Workspaces
myNormalBorderColor  = "#474747" --Unfocused border color
myFocusedBorderColor = "#808080" --Focused border color

-- Key bindings

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    [ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)

    -- launch dmenu
    , ((modm,               xK_p     ), spawn "sh ~/.config/rofi/launchers/colorful/launcher.sh")

    -- close focused window
    , ((modm .|. shiftMask, xK_c     ), kill)

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
    , ((modm .|. shiftMask, xK_q     ), spawn "./.config/rofi/bin/menu_powermenu")
    , ((modm .|. shiftMask, xK_h     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_q     ), spawn "xmonad --recompile; xmonad --restart")

    , ((0, xF86XK_AudioLowerVolume   ), spawn "pactl set-sink-volume 0 -1.5%")
    , ((0, xF86XK_AudioRaiseVolume   ), spawn "pactl set-sink-volume 0 +1.5%")
    , ((0, xF86XK_AudioMute          ), spawn "amixer set Master toggle")

    , ((modm .|. shiftMask, xK_s     ), spawn "flameshot gui")
    ]
    ++

    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++

    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    [((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


-- Mouse bindings

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]


-- MyPP

myPP :: PP
myPP = defaultPP
        { ppCurrent = xmobarColor "#34eb40" "" . wrap "[" "]"
        , ppLayout = xmobarColor "#eb901a" ""
        , ppTitle = xmobarColor "#1ad6eb" ""
        }

-- Layouts:

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = smartSpacing 8 $ Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

--Window rules

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore
    , manageDocks ]

-- Event handling

-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.

myEventHook = mempty

-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.

myLogHook = do
	dynamicLogString myPP >>= xmonadPropLog

-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is restarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
-- By default, do nothing.

myStartupHook = do
   spawnOnce "nitrogen --set-zoom-fill ~/Wallpaper.jpg"
   spawnOnce "picom &"
   spawnOnce "xmobar -x 0 ~/.config/xmobar/xmobar.conf"
   spawnOnce "dunst"
   spawnOnce "dunstify -u low 'Hey!' 'Dunst started up.'"
   spawnOnce "trayer --edge top --align right --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 --tint 0x333333  --height 19 &"
   spawnOnce "xsetroot -cursor_name left_ptr"

-- Now run xmonad with all the defaults we set up.
-- Run xmonad with the settings you specify. No need to modify this.

main = do
	h <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xmobar.conf"
	xmonad . docks $ def {
		--Defines Variables to Variables.
	        terminal           = myTerminal,
	        focusFollowsMouse  = myFocusFollowsMouse,
	        clickJustFocuses   = myClickJustFocuses,
	        borderWidth        = myBorderWidth,
	        modMask            = myModMask,
	        workspaces         = myWorkspaces,
	        normalBorderColor  = myNormalBorderColor,
	        focusedBorderColor = myFocusedBorderColor,

	        --Key bindings
 	        keys               = myKeys,
 	        mouseBindings      = myMouseBindings,

  	        --hooks, layouts
 	        layoutHook         = smartBorders myLayout,
	        manageHook         = myManageHook,
	        handleEventHook    = myEventHook,
	        logHook            = myLogHook,
	        startupHook        = myStartupHook
    	}
