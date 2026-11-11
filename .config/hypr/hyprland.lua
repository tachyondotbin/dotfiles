
-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
dofile(os.getenv("HOME") .. "/.config/hypr/hyprsound.lua")

-- Cursor
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

-- Dark mode / toolkits
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "kde")   -- needs plasma-integration; use "qt6ct" if you don't have it
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("ADW_DEBUG_COLOR_SCHEME", "prefer-dark")

-- Intel iGPU: hardware video decode (Firefox VA-API)
hl.env("LIBVA_DRIVER_NAME", "iHD")
-- Electron apps (VS Code etc.) run native Wayland instead of XWayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- Screenshots
hl.env("HYPRSHOT_DIR", os.getenv("HOME") .. "/Pictures/Screenshots")


------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})

hl.monitor({
    output = "HDMI-A-1",
    mode = "1680x1050@60",
    position = "auto-right",
    scale = 1,
    transform = 3
})

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 2%+"), { locked = true, repeating = true }) -- | WORKING
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 2%-"), { locked = true, repeating = true })  -- |

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "kitty"          -- or "kitty --single-instance" to save RAM
local fileManager = "dolphin"
local menu        = "hyprlauncher"


-------------------
---- AUTOSTART ----
-------------------
-- One-time theme setup (gsettings, gtk settings.ini, flatpak override) is NOT here:
-- run it once by hand, it persists. Only per-session things belong at startup.

hl.on("hyprland.start", function()
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    -- hl.exec_cmd("hypridle")   -- dim / lock / screen off / suspend (needs ~/.config/hypr/hypridle.conf)

    -- XWayland-only theming (Steam etc.). Remove both lines if you don't use X11 apps.
    hl.exec_cmd([[echo -e "Steam*Background: #1b2838\nSteam*Foreground: #c7d5e0\n*Background: #242424\n*Foreground: #ffffff" | xrdb -merge]])
    hl.exec_cmd([[echo 'Net/ThemeName "Adwaita-dark"' > ~/.xsettingsd && xsettingsd &]])
end)


-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 0,
        gaps_out = 0,
        border_size = 0,

        col = {
            active_border   = { colors = {"rgba(33ccffee)", "rgba(00ff99ee)"}, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding         = 0,      -- no gaps/borders, so rounded corners only cost shader work
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = { enabled = false },
        blur   = { enabled = false },
    },

    -- All animations off: no curves or animation rules needed
    animations = {
        enabled = false,
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    debug = {
	vfr = true
    },
    render = {
--	direct_scanout = 2, -- 0 1 2
    },
    misc = {
	render_unfocused_fps = 5,
        force_default_wallpaper  = 0,-- no mascot wallpapers
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
        mouse_move_enables_dpms  = true,   -- wake screen after hypridle turns it off
        key_press_enables_dpms   = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us,ru",
        kb_variant = "",
        kb_model   = "",
        kb_options = "grp:ctrl_space_toggle",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            disable_while_typing = false,
            natural_scroll       = true,
        },
    },
})

hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})


---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Screenshot
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region"))

-- Move focus
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Workspaces 1-10
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scratchpad
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })



--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
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
