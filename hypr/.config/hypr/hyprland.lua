
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Hyprland config — scrolling layout rice                --
-- https://wiki.hypr.land/Configuring/Start/             --
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
    output   = "DP-3",
    mode     = "3440x1440@180",
    position = "0x0",
    scale    = "1",
})


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "wezterm"
local browser     = "vivaldi"
local fileManager = "dolphin"

-- Noctalia IPC helper
local function noc(cmd) return hl.dsp.exec_cmd("noctalia msg " .. cmd) end


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function () 
  hl.exec_cmd("noctalia")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 8,

        border_size = 2,

        -- Colors are overridden after require("noctalia") at the bottom
        col = {
            active_border   = { colors = { "rgba(67ace4ee)", "rgba(5c61d6ee)" }, angle = 45 },
            inactive_border = "rgba(0d2030aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "scrolling",
    },

    decoration = {
        rounding       = 20,
        rounding_power = 2,

        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 6,
            render_power = 3,
            color        = "rgba(0d2030cc)",   -- surface-tinted navy
        },

        blur = {
            enabled  = false,
            size     = 3,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Springs
hl.curve("easy",   { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })
hl.curve("snappy", { type = "spring", mass = 1, stiffness = 95,      dampening = 17 })          -- tighter column stops

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 5.2,  spring = "snappy" })      -- snappier column entry
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "snappy",       style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",        style = "popin 87%" })
hl.animation({ leaf = "windowsMove",   enabled = true,  speed = 5.0,  spring = "snappy" })      -- column scroll/reorder
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint",  style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",        style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear",  style = "slidefade 15%" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear",  style = "slidefade 15%" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear",  style = "slidefade 15%" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
        column_width             = 0.5,               -- default: half of 3440px
        focus_fit_method         = 1,                 -- 1 = fit column fully into view
        follow_focus             = true,
        explicit_column_widths   = "0.333, 0.5, 0.667, 1.0",
        wrap_focus               = true,
        wrap_swapcol             = true,
        direction                = "right",
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "br",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- ── Apps ─────────────────────────────────────────────────────────────────────
hl.bind(mainMod .. " + Return",     hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B",          hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W",          hl.dsp.window.close())
hl.bind(mainMod .. " + V",          hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F",          hl.dsp.layout "colresize 1.0")    -- maximize column width
hl.bind(mainMod .. " + SHIFT + F",  hl.dsp.window.fullscreen())        -- actual fullscreen
hl.bind(mainMod .. " + P",          hl.dsp.window.pseudo())

-- ── Noctalia Shell ───────────────────────────────────────────────────────────
hl.bind(mainMod .. " + space",       noc "panel-toggle launcher")
hl.bind(mainMod .. " + Tab",         noc "window-switcher")
hl.bind(mainMod .. " + SHIFT + V",   noc "panel-open launcher /clip")
hl.bind(mainMod .. " + period",      noc "panel-open launcher /emo")
hl.bind(mainMod .. " + O",           noc "panel-toggle control-center")
hl.bind(mainMod .. " + comma",       noc "settings-toggle")
hl.bind(mainMod .. " + A",           noc "panel-toggle calendar")
hl.bind(mainMod .. " + M",           noc "panel-toggle system-monitor")
hl.bind(mainMod .. " + X",           noc "panel-toggle session-menu")
hl.bind(mainMod .. " + SHIFT + X",   noc "session lock-and-suspend")
hl.bind(mainMod .. " + Escape",      noc "session lock")

-- ── Scrolling layout — focus ──────────────────────────────────────────────────
-- Horizontal: move between columns; Vertical: move between stacked windows in a column
hl.bind(mainMod .. " + H",     hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",     hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",     hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",     hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- ── Scrolling layout — column manipulation ────────────────────────────────────
-- H/L: move the focused column left/right
-- J/K: swap the focused window down/up within its column
hl.bind(mainMod .. " + SHIFT + H",   hl.dsp.layout("move -col"))
hl.bind(mainMod .. " + SHIFT + L",   hl.dsp.layout("move +col"))
hl.bind(mainMod .. " + SHIFT + J",   hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K",   hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + H",    hl.dsp.layout("swapcol l"))
hl.bind(mainMod .. " + CTRL + L",    hl.dsp.layout("swapcol r"))
hl.bind(mainMod .. " + R",           hl.dsp.layout("colresize +conf"))  -- cycle width fwd
hl.bind(mainMod .. " + SHIFT + R",   hl.dsp.layout("colresize -conf"))  -- cycle width back
-- Stack windows vertically (Niri-style consume/expel)
-- Super+G: pull the window to the right into the current column (stack below)
-- Super+Shift+G: eject the focused window into its own column
hl.bind(mainMod .. " + G",           hl.dsp.layout("consume"))
hl.bind(mainMod .. " + SHIFT + G",   hl.dsp.layout("expel"))
hl.bind(mainMod .. " + bracketright",hl.dsp.layout("consume_or_expel next"))
hl.bind(mainMod .. " + bracketleft", hl.dsp.layout("consume_or_expel prev"))
hl.bind(mainMod .. " + SHIFT + Return", hl.dsp.layout("promote"))       -- promote to own column
hl.bind(mainMod .. " + BackSpace",         hl.dsp.layout "fit active")  -- fit focused column into view
hl.bind(mainMod .. " + SHIFT + BackSpace", hl.dsp.layout "fit all")    -- fit all columns

-- ── Workspaces ────────────────────────────────────────────────────────────────
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special "magic")
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces with mainMod + scroll wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ── Media / brightness ────────────────────────────────────────────────────────
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-",      { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle",   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%+",                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd "brightnessctl -e4 -n2 set 5%-",                  { locked = true, repeating = true })
hl.bind("XF86AudioNext",         hl.dsp.exec_cmd "playerctl next",        { locked = true })
hl.bind("XF86AudioPause",        hl.dsp.exec_cmd "playerctl play-pause",  { locked = true })
hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd "playerctl play-pause",  { locked = true })
hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd "playerctl previous",    { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local suppressMaximizeRule = hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },
    move  = "20 monitor_h-120",
    float = true,
})

-- ── Scrolling layout — default column widths ──────────────────────────────────
-- Widths align with explicit_column_widths presets (0.333 / 0.5 / 0.667 / 1.0)
hl.window_rule({ name = "col-terminal", match = { class = "(?i)(wezterm|org.wezfurlong.wezterm|kitty|Alacritty)" },   size = "50% 100%" })
hl.window_rule({ name = "col-browser",  match = { class = "(?i)(firefox|zen|chromium|google-chrome|brave-browser)" }, size = "67% 100%" })
hl.window_rule({ name = "col-editor",   match = { class = "(?i)(code|code-oss|jetbrains-.*|neovide)" },               size = "67% 100%" })
hl.window_rule({ name = "col-files",    match = { class = "(?i)(dolphin|org.kde.dolphin|nautilus|thunar)" },           size = "50% 100%" })
hl.window_rule({ name = "col-chat",     match = { class = "(?i)(discord|vesktop|slack|telegram-desktop|signal)" },    size = "33% 100%" })

-- ── Float rules ───────────────────────────────────────────────────────────────
hl.window_rule({ name = "float-system",  match = { class = "(?i)(pavucontrol|blueman-manager|nm-connection-editor|org.kde.polkit-kde-authentication-agent-1)" }, float = true })
hl.window_rule({ name = "float-pip",     match = { title = "(?i)picture.in.picture" },                                float = true, pin = true })
hl.window_rule({ name = "float-portals", match = { class = "(?i)(xdg-desktop-portal-kde)" },                          float = true })

-- For Noctalia Color templates
require("noctalia")

-- ── Border gradient (must be AFTER require("noctalia") — overrides its flat border)
hl.config({ general = { col = {
    active_border   = { colors = { "rgba(67ace4ee)", "rgba(5c61d6ee)" }, angle = 45 },
    inactive_border = "rgba(0d2030aa)",
}}})
