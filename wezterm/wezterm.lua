-- Pull in the wezterm API
local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local act = wezterm.action

local opacity = 0.98

config.color_scheme = 'zenbones_dark'
config.tab_bar_at_bottom = true
-- config.hide_tab_bar_if_only_one_tab = false

-- config.font = wezterm.font_with_fallback{
--     { family = "Cica", weight = 'Regular'},
--     "JetBrains Mono",
-- }
config.font_size = 13.0

config.window_background_opacity = opacity
config.text_background_opacity = 0.7


config.enable_scroll_bar = true
config.colors = {
    scrollbar_thumb = '#52ad70',
    split = 'silver',
}


-- Shows the currently active key table on the right side of the status bar.
wezterm.on('update-right-status', function(window, pane)
  local name = window:active_key_table()
  if name then
    name = 'TABLE: ' .. name .. '. Press Esc to exit.'
  end
  window:set_right_status(name or '')
end)


wezterm.on('toggle-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  if not overrides.window_background_opacity then
    overrides.window_background_opacity = 0.7
  else
    overrides.window_background_opacity = nil
  end
  window:set_config_overrides(overrides)
end)


-- Shows the current pane title inside tab.
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
return {
    {Text=" " .. tab.active_pane.title .. " "},
}
end)

config.disable_default_key_bindings = true
-- timeout_milliseconds defaults to 1000 and can be omitted
config.leader = { key = 'q', mods = 'ALT', timeout_milliseconds = 1000 }
config.keys = {
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "LEADER", action = act.ShowTabNavigator },

  { key = "\\", mods = "LEADER", action = act.SplitHorizontal{ domain = "CurrentPaneDomain" } },
  { key = "-", mods = "LEADER", action = act.SplitVertical{ domain = "CurrentPaneDomain" } },
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },
  { key = "h", mods = "LEADER", action = act.AdjustPaneSize{"Left", 10} },
  { key = "l", mods = "LEADER", action = act.AdjustPaneSize{"Right", 10} },
  { key = "k", mods = "LEADER", action = act.AdjustPaneSize{"Up", 5} },
  { key = "j", mods = "LEADER", action = act.AdjustPaneSize{"Down", 5} },

  { key = 'r', mods = 'LEADER', action = act.ActivateKeyTable {
      name = 'resize_pane',
      one_shot = false,
    },
  },


  { key = "f", mods = "LEADER", action = act.ToggleFullScreen },

  { key = "x", mods = "CTRL|SHIFT", action = act.ActivateCopyMode },
  { key = 't', mods = 'CTRL', action = act.SpawnTab 'CurrentPaneDomain'}, 
  { key = "v", mods = "CTRL|SHIFT", action = act.PasteFrom("Clipboard") },
  { key = "c", mods = "CTRL|SHIFT", action = act.CopyTo("Clipboard") },
  { key = 'o', mods = 'LEADER', action = act.EmitEvent 'toggle-opacity'},
  { key = '=', mods = 'CTRL', action = wezterm.action.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = wezterm.action.DecreaseFontSize },

}

config.key_tables = {
  resize_pane = {
    { key = 'LeftArrow', action = act.AdjustPaneSize { 'Left', 1 } },
    { key = 'h', action = act.AdjustPaneSize { 'Left', 1 } },

    { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
    { key = 'l', action = act.AdjustPaneSize { 'Right', 1 } },

    { key = 'UpArrow', action = act.AdjustPaneSize { 'Up', 1 } },
    { key = 'k', action = act.AdjustPaneSize { 'Up', 1 } },

    { key = 'DownArrow', action = act.AdjustPaneSize { 'Down', 1 } },
    { key = 'j', action = act.AdjustPaneSize { 'Down', 1 } },

    -- Cancel the mode by pressing escape
    { key = 'Escape', action = 'PopKeyTable' },
  },
}

return config
