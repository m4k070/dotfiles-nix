-- Hyprland Configuration (Lua)
-- Based on official example: https://github.com/hyprwm/Hyprland/blob/main/example/hyprland.lua

---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "nautilus"
local menu        = "fuzzel"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("fcitx5 -d")
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in  = 5,
        gaps_out = 10,
        border_size = 4,

        col = {
            active_border   = "0xc9b890ff",
            inactive_border = "0x444444ff",
        },

        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 6,
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = false,
        },

        blur = {
            enabled = false,
        },
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_options = "",
        repeat_rate = 25,
        repeat_delay = 600,
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
            tap_to_click = true,
        },
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
    },
})

hl.config({
    binds = {
        workspace_back_and_forth = true,
    },
})

hl.config({
    dwindle = {
        preserve_split = true,
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

-- Launch apps
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exit())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.window.float({ action = "unset", window = "floating" }))
hl.bind(mainMod .. " + CTRL + V", hl.dsp.window.float({ action = "set", window = "tiled" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

-- Focus movement (arrows)
hl.bind(mainMod .. " + LEFT", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + RIGHT", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + UP", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + DOWN", hl.dsp.focus({ direction = "down" }))

-- Focus movement (vim)
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))

-- Window exchange (arrows)
hl.bind(mainMod .. " + CTRL + LEFT", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + RIGHT", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + UP", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + DOWN", hl.dsp.window.swap({ direction = "down" }))

-- Window exchange (vim)
hl.bind(mainMod .. " + CTRL + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + J", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + L", hl.dsp.window.swap({ direction = "right" }))

-- Move window (arrows)
hl.bind(mainMod .. " + SHIFT + LEFT", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + RIGHT", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + UP", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + DOWN", hl.dsp.window.move({ direction = "down" }))

-- Move window (vim)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- Make active window main tile
hl.bind(mainMod .. " + RETURN", hl.dsp.layout("movetoroot"))

-- Workspace navigation
hl.bind(mainMod .. " + U", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + PAGE_UP", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + PAGE_DOWN", hl.dsp.focus({ workspace = "e+1" }))

-- Move window to workspace
hl.bind(mainMod .. " + CTRL + U", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + I", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + PAGE_UP", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + PAGE_DOWN", hl.dsp.window.move({ workspace = "e+1" }))

-- Move window to workspace (shift)
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + I", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + SHIFT + PAGE_UP", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(mainMod .. " + SHIFT + PAGE_DOWN", hl.dsp.window.move({ workspace = "e+1" }))

-- Switch workspaces
for i = 1, 9 do
    hl.bind(mainMod .. " + " .. tostring(i), hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + CTRL + " .. tostring(i), hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + CTRL + mouse_down", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(mainMod .. " + CTRL + mouse_up", hl.dsp.window.move({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --class=backlight set +10%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class=backlight set 10%-"), { locked = true, repeating = true })

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast save output"))

-- Toggle layout
hl.bind(mainMod .. " + SPACE", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.layout("rotatesplit"))
hl.bind(mainMod .. " + CTRL + SPACE", hl.dsp.layout("splitratio 1.0 exact"))

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "float-bitwarden",
    match = { class = "Bitwarden" },
    float = true,
})

hl.window_rule({
    name  = "float-pip",
    match = { title = "Picture%-in%-Picture" },
    float = true,
})

hl.window_rule({
    name  = "float-pip-jp",
    match = { title = "ピクチャーインピクチャー" },
    float = true,
})

hl.window_rule({
    name  = "float-fcitx",
    match = { class = "fcitx" },
    float = true,
})
