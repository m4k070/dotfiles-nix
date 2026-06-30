-- Hyprland Configuration (Lua)

-- Autostart
hl.exec_cmd("noctalia")
hl.exec_cmd("fcitx5 -d")

-- Configuration
hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 4,
    ["col.active_border"] = "0xc9b890ff",
    ["col.inactive_border"] = "0x444444ff",
    layout = "dwindle",
  },
  decoration = {
    rounding = 6,
    drop_shadow = false,
    blur = { enabled = false },
    active_opacity = 1.0,
    inactive_opacity = 1.0,
  },
  animations = {
    enabled = true,
    animation = {
      { "window", 1, 400, "default", "slide" },
      { "fade", 1, 400, "default" },
      { "workspaces", 1, 400, "default" },
    },
  },
  input = {
    kb_options = "",
    repeat_rate = 25,
    repeat_delay = 600,
    follow_mouse = 1,
    touchpad = {
      natural_scroll = true,
      tap_to_click = true,
    },
  },
  misc = {
    force_default_wallpaper = 0,
  },
  binds = {
    workspace_back_and_forth = true,
  },
})

-- Helper function for dispatchers not in Lua API
local function dispatch(cmd)
  return hl.dsp.exec_cmd("hyprctl dispatch " .. cmd)
end

-- Key Bindings
-- Reload / Launch
hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + Q", hl.dsp.window.close)
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen)
hl.bind("SUPER + V", hl.dsp.window.float)
hl.bind("SUPER + SHIFT + V", dispatch("workspaceopt allfloat"))
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd("hyprctl switchxkblayout next"))
hl.bind("SUPER + F", hl.dsp.window.fullscreen)

-- Focus movement (arrows)
hl.bind("SUPER + LEFT", dispatch("movefocus l"))
hl.bind("SUPER + RIGHT", dispatch("movefocus r"))
hl.bind("SUPER + UP", dispatch("movefocus u"))
hl.bind("SUPER + DOWN", dispatch("movefocus d"))

-- Focus movement (vim)
hl.bind("SUPER + H", dispatch("movefocus l"))
hl.bind("SUPER + J", dispatch("movefocus d"))
hl.bind("SUPER + K", dispatch("movefocus u"))
hl.bind("SUPER + L", dispatch("movefocus r"))

-- Window exchange (arrows)
hl.bind("SUPER + CTRL + LEFT", dispatch("movewindoworgroup l"))
hl.bind("SUPER + CTRL + RIGHT", dispatch("movewindoworgroup r"))
hl.bind("SUPER + CTRL + UP", dispatch("movewindoworgroup u"))
hl.bind("SUPER + CTRL + DOWN", dispatch("movewindoworgroup d"))

-- Window exchange (vim)
hl.bind("SUPER + CTRL + H", dispatch("movewindoworgroup l"))
hl.bind("SUPER + CTRL + J", dispatch("movewindoworgroup d"))
hl.bind("SUPER + CTRL + K", dispatch("movewindoworgroup u"))
hl.bind("SUPER + CTRL + L", dispatch("movewindoworgroup r"))

-- Monitor focus (arrows)
hl.bind("SUPER + SHIFT + LEFT", dispatch("focusmonitor l"))
hl.bind("SUPER + SHIFT + RIGHT", dispatch("focusmonitor r"))
hl.bind("SUPER + SHIFT + UP", dispatch("focusmonitor u"))
hl.bind("SUPER + SHIFT + DOWN", dispatch("focusmonitor d"))

-- Monitor focus (vim)
hl.bind("SUPER + SHIFT + H", dispatch("focusmonitor l"))
hl.bind("SUPER + SHIFT + J", dispatch("focusmonitor d"))
hl.bind("SUPER + SHIFT + K", dispatch("focusmonitor u"))
hl.bind("SUPER + SHIFT + L", dispatch("focusmonitor r"))

-- Move window to monitor (arrows)
hl.bind("SUPER + SHIFT + CTRL + LEFT", dispatch("movewindow mon:l"))
hl.bind("SUPER + SHIFT + CTRL + RIGHT", dispatch("movewindow mon:r"))
hl.bind("SUPER + SHIFT + CTRL + UP", dispatch("movewindow mon:u"))
hl.bind("SUPER + SHIFT + CTRL + DOWN", dispatch("movewindow mon:d"))

-- Move window to monitor (vim)
hl.bind("SUPER + SHIFT + CTRL + H", dispatch("movewindow mon:l"))
hl.bind("SUPER + SHIFT + CTRL + J", dispatch("movewindow mon:d"))
hl.bind("SUPER + SHIFT + CTRL + K", dispatch("movewindow mon:u"))
hl.bind("SUPER + SHIFT + CTRL + L", dispatch("movewindow mon:r"))

-- Workspace navigation
hl.bind("SUPER + U", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + I", hl.dsp.workspace.move("e+1"))
hl.bind("SUPER + PAGE_UP", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + PAGE_DOWN", hl.dsp.workspace.move("e+1"))

hl.bind("SUPER + CTRL + U", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + CTRL + I", hl.dsp.workspace.move("e+1"))
hl.bind("SUPER + CTRL + PAGE_UP", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + CTRL + PAGE_DOWN", hl.dsp.workspace.move("e+1"))

hl.bind("SUPER + SHIFT + U", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + SHIFT + I", hl.dsp.workspace.move("e+1"))
hl.bind("SUPER + SHIFT + PAGE_UP", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + SHIFT + PAGE_DOWN", hl.dsp.workspace.move("e+1"))

-- Direct workspace access
for i = 1, 9 do
  hl.bind("SUPER + " .. tostring(i), hl.dsp.workspace.move(tostring(i)))
  hl.bind("SUPER + CTRL + " .. tostring(i), hl.dsp.workspace.move(tostring(i)))
end

-- Resize
hl.bind("SUPER + MINUS", dispatch("resizeactive -50 0"))
hl.bind("SUPER + EQUAL", dispatch("resizeactive 50 0"))
hl.bind("SUPER + SHIFT + MINUS", dispatch("resizeactive 0 -50"))
hl.bind("SUPER + SHIFT + EQUAL", dispatch("resizeactive 0 50"))

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast save output"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl --class=backlight set +10%"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl --class=backlight set 10%-"), { repeating = true })

-- Mouse bindings
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Scroll wheel workspace switching
hl.bind("SUPER + mouse_up", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + mouse_down", hl.dsp.workspace.move("e+1"))
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.workspace.move("e-1"))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.workspace.move("e+1"))

-- Window rules
hl.window_rule({
  match = { class = "Bitwarden" },
  float = true,
})
hl.window_rule({
  match = { title = "Picture%-in%-Picture" },
  float = true,
})
hl.window_rule({
  match = { title = "ピクチャーインピクチャー" },
  float = true,
})
hl.window_rule({
  match = { class = "fcitx" },
  float = true,
})
