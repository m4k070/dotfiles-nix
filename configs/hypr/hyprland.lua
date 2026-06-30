-- Hyprland Configuration (Lua)

-- Autostart
hl.exec("noctalia")
hl.exec("fcitx5 -d")

-- General
hl.general({
  gaps_in = 5,
  gaps_out = 10,
  border_size = 4,
  ["col.active_border"] = "0xc9b890ff",
  ["col.inactive_border"] = "0x444444ff",
  layout = "dwindle",
})

-- Decoration
hl.decoration({
  rounding = 6,
  drop_shadow = false,
  blur = { enabled = false },
  active_opacity = 1.0,
  inactive_opacity = 1.0,
})

-- Animations
hl.animations({
  enabled = true,
  animation = {
    { "window", 1, 400, "default", "slide" },
    { "fade", 1, 400, "default" },
    { "workspaces", 1, 400, "default" },
  },
})

-- Input
hl.input({
  kb_options = "",
  repeat_rate = 25,
  repeat_delay = 600,
  follow_mouse = 1,
  touchpad = {
    natural_scroll = true,
    tap = true,
  },
})

-- Misc
hl.misc({
  force_default_wallpaper = 0,
})

-- Binds options
hl.binds({
  workspace_back_and_forth = true,
})

-- Key Bindings
-- Reload / Launch
hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))
hl.bind("SUPER + Q", hl.dsp.closewindow())
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind("SUPER + SHIFT + F", hl.dsp.fullscreen())
hl.bind("SUPER + V", hl.dsp.togglefloating())
hl.bind("SUPER + SHIFT + V", hl.dsp.workspaceopt("allfloat"))
hl.bind("SUPER + SPACE", hl.dsp.switchlayout("next"))
hl.bind("SUPER + F", hl.dsp.fullscreen("0"))

-- Focus movement (arrows)
hl.bind("SUPER + LEFT", hl.dsp.movefocus("l"))
hl.bind("SUPER + RIGHT", hl.dsp.movefocus("r"))
hl.bind("SUPER + UP", hl.dsp.movefocus("u"))
hl.bind("SUPER + DOWN", hl.dsp.movefocus("d"))

-- Focus movement (vim)
hl.bind("SUPER + H", hl.dsp.movefocus("l"))
hl.bind("SUPER + J", hl.dsp.movefocus("d"))
hl.bind("SUPER + K", hl.dsp.movefocus("u"))
hl.bind("SUPER + L", hl.dsp.movefocus("r"))

-- Window exchange (arrows)
hl.bind("SUPER + CTRL + LEFT", hl.dsp.movewindoworgroup("l"))
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.movewindoworgroup("r"))
hl.bind("SUPER + CTRL + UP", hl.dsp.movewindoworgroup("u"))
hl.bind("SUPER + CTRL + DOWN", hl.dsp.movewindoworgroup("d"))

-- Window exchange (vim)
hl.bind("SUPER + CTRL + H", hl.dsp.movewindoworgroup("l"))
hl.bind("SUPER + CTRL + J", hl.dsp.movewindoworgroup("d"))
hl.bind("SUPER + CTRL + K", hl.dsp.movewindoworgroup("u"))
hl.bind("SUPER + CTRL + L", hl.dsp.movewindoworgroup("r"))

-- Monitor focus (arrows)
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.focusmonitor("l"))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.focusmonitor("r"))
hl.bind("SUPER + SHIFT + UP", hl.dsp.focusmonitor("u"))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.focusmonitor("d"))

-- Monitor focus (vim)
hl.bind("SUPER + SHIFT + H", hl.dsp.focusmonitor("l"))
hl.bind("SUPER + SHIFT + J", hl.dsp.focusmonitor("d"))
hl.bind("SUPER + SHIFT + K", hl.dsp.focusmonitor("u"))
hl.bind("SUPER + SHIFT + L", hl.dsp.focusmonitor("r"))

-- Move window to monitor (arrows)
hl.bind("SUPER + SHIFT + CTRL + LEFT", hl.dsp.movewindow("mon:l"))
hl.bind("SUPER + SHIFT + CTRL + RIGHT", hl.dsp.movewindow("mon:r"))
hl.bind("SUPER + SHIFT + CTRL + UP", hl.dsp.movewindow("mon:u"))
hl.bind("SUPER + SHIFT + CTRL + DOWN", hl.dsp.movewindow("mon:d"))

-- Move window to monitor (vim)
hl.bind("SUPER + SHIFT + CTRL + H", hl.dsp.movewindow("mon:l"))
hl.bind("SUPER + SHIFT + CTRL + J", hl.dsp.movewindow("mon:d"))
hl.bind("SUPER + SHIFT + CTRL + K", hl.dsp.movewindow("mon:u"))
hl.bind("SUPER + SHIFT + CTRL + L", hl.dsp.movewindow("mon:r"))

-- Workspace navigation
hl.bind("SUPER + U", hl.dsp.workspace("e-1"))
hl.bind("SUPER + I", hl.dsp.workspace("e+1"))
hl.bind("SUPER + PAGE_UP", hl.dsp.workspace("e-1"))
hl.bind("SUPER + PAGE_DOWN", hl.dsp.workspace("e+1"))

hl.bind("SUPER + CTRL + U", hl.dsp.movetoworkspace("e-1"))
hl.bind("SUPER + CTRL + I", hl.dsp.movetoworkspace("e+1"))
hl.bind("SUPER + CTRL + PAGE_UP", hl.dsp.movetoworkspace("e-1"))
hl.bind("SUPER + CTRL + PAGE_DOWN", hl.dsp.movetoworkspace("e+1"))

hl.bind("SUPER + SHIFT + U", hl.dsp.movetoworkspace("e-1"))
hl.bind("SUPER + SHIFT + I", hl.dsp.movetoworkspace("e+1"))
hl.bind("SUPER + SHIFT + PAGE_UP", hl.dsp.movetoworkspace("e-1"))
hl.bind("SUPER + SHIFT + PAGE_DOWN", hl.dsp.movetoworkspace("e+1"))

-- Direct workspace access
for i = 1, 9 do
  hl.bind("SUPER + " .. tostring(i), hl.dsp.workspace(tostring(i)))
  hl.bind("SUPER + CTRL + " .. tostring(i), hl.dsp.movetoworkspace(tostring(i)))
end

-- Resize
hl.bind("SUPER + MINUS", hl.dsp.resizeactive("-50 0"))
hl.bind("SUPER + EQUAL", hl.dsp.resizeactive("50 0"))
hl.bind("SUPER + SHIFT + MINUS", hl.dsp.resizeactive("0 -50"))
hl.bind("SUPER + SHIFT + EQUAL", hl.dsp.resizeactive("0 50"))

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
hl.bind("SUPER + mouse_up", hl.dsp.workspace("e-1"))
hl.bind("SUPER + mouse_down", hl.dsp.workspace("e+1"))
hl.bind("SUPER + CTRL + mouse_up", hl.dsp.movetoworkspace("e-1"))
hl.bind("SUPER + CTRL + mouse_down", hl.dsp.movetoworkspace("e+1"))

-- Window rules
hl.windowrule("float", "class:^(Bitwarden)$")
hl.windowrule("float", "title:^(Picture-in-Picture)$")
hl.windowrule("float", "title:^(ピクチャーインピクチャー)$")
hl.windowrule("float", "class:^(fcitx)$")
