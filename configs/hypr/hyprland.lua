-- Hyprland Configuration (Lua) - Minimal Working Config

-- Autostart
hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
  hl.exec_cmd("fcitx5 -d")
end)

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

-- Key Bindings
-- Reload config
hl.bind("SUPER + R", hl.dsp.exec_cmd("hyprctl reload"))

-- Launch apps
hl.bind("SUPER + T", hl.dsp.exec_cmd("ghostty"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd("noctalia msg session lock"))

-- Window management (using direct dispatchers)
hl.bind("SUPER + Q", hl.dsp.window.close)
hl.bind("SUPER + SHIFT + E", hl.dsp.exit())
hl.bind("SUPER + SHIFT + F", hl.dsp.window.fullscreen)
hl.bind("SUPER + V", hl.dsp.window.float)
hl.bind("SUPER + F", hl.dsp.window.fullscreen)

-- Focus movement (using hyprctl dispatch for compatibility)
hl.bind("SUPER + H", hl.dsp.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind("SUPER + J", hl.dsp.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind("SUPER + K", hl.dsp.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind("SUPER + L", hl.dsp.exec_cmd("hyprctl dispatch movefocus r"))

-- Workspace navigation
hl.bind("SUPER + U", hl.dsp.exec_cmd("hyprctl dispatch workspace e-1"))
hl.bind("SUPER + I", hl.dsp.exec_cmd("hyprctl dispatch workspace e+1"))

-- Direct workspace access
for i = 1, 9 do
  hl.bind("SUPER + " .. tostring(i), hl.dsp.exec_cmd("hyprctl dispatch workspace " .. tostring(i)))
end

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+ -l 1.0"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })

-- Screenshot
hl.bind("PRINT", hl.dsp.exec_cmd("grimblast save output"))

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
  match = { class = "fcitx" },
  float = true,
})
