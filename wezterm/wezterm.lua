local wezterm = require "wezterm"
local config = wezterm.config_builder()
 
config.color_scheme = "Tokyo Night"
config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.initial_cols = 999
config.initial_rows = 999

config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 14.0

config.window_padding = {
  left = 20,
  right = 20,
  top = 10,
  bottom = 10,
}

config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.default_cursor_style = "BlinkingBar"
config.animation_fps = 60

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.6,
}

config.keys = {
  -- Multi-line input support (Shift+Enter for newline without submitting)
  { key = "Enter", mods = "SHIFT", action = wezterm.action.SendString "\x1b\r" },

  -- Tab management
  { key = "t", mods = "CMD", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentTab { confirm = true } },

  -- Tab navigation
  { key = "1", mods = "CMD", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "CMD", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "CMD", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "CMD", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "CMD", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "CMD", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "CMD", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "CMD", action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "CMD", action = wezterm.action.ActivateTab(8) },

  -- Disable default assignments for arrow keys
  { key = "LeftArrow", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },
  { key = "RightArrow", mods = "CTRL|SHIFT", action = "DisableDefaultAssignment" },

  -- IDE-like cursor movement and selection
  -- Option + arrows: move by word
  { key = "LeftArrow", mods = "OPT", action = wezterm.action.SendKey { key = "b", mods = "ALT" } },
  { key = "RightArrow", mods = "OPT", action = wezterm.action.SendKey { key = "f", mods = "ALT" } },

  -- Cmd + arrows: move to line start/end
  { key = "LeftArrow", mods = "CMD", action = wezterm.action.SendKey { key = "a", mods = "CTRL" } },
  { key = "RightArrow", mods = "CMD", action = wezterm.action.SendKey { key = "e", mods = "CTRL" } },

  -- Shift + Cmd + arrows: select to line start/end
  { key = "LeftArrow", mods = "SHIFT|CMD", action = wezterm.action.SendString "\x1b[1;6H" },
  { key = "RightArrow", mods = "SHIFT|CMD", action = wezterm.action.SendString "\x1b[1;6F" },

  -- Scroll to bottom
  { key = "DownArrow", mods = "CMD", action = wezterm.action.ScrollToBottom },

  -- Paste from clipboard
  { key = "v", mods = "CMD", action = wezterm.action.PasteFrom "Clipboard" },
}

config.mouse_bindings = {
  -- Cmd+click to open links (instead of Ctrl+click)
  {
    event = { Up = { streak = 1, button = "Left" } },
    mods = "CMD",
    action = wezterm.action.OpenLinkAtMouseCursor,
  },
}

return config
