-- Pull in the wezterm API
local wezterm = require("wezterm")

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return "Dark"
end

local function scheme_for_appearance(appearance)
  if appearance:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local config = wezterm.config_builder()
bar.apply_to_config(config)

config.initial_cols = 120
config.initial_rows = 28

config.font_size = 14
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.scrollback_lines = 100000
config.color_scheme = scheme_for_appearance(get_appearance())
config.window_decorations = "RESIZE"

config.window_frame = {
  inactive_titlebar_bg = "#353535",
  active_titlebar_bg = "#181825",
  inactive_titlebar_fg = "#cccccc",
  active_titlebar_fg = "#ffffff",
  inactive_titlebar_border_bottom = "#2b2042",
  active_titlebar_border_bottom = "#2b2042",
  button_fg = "#cccccc",
  button_bg = "#2b2042",
  button_hover_fg = "#ffffff",
  button_hover_bg = "#3b3052",
}

config.keys = {
  {
    key = "LeftArrow",
    mods = "CMD",
    action = wezterm.action({ SendString = "\x1bOH" }),
  },
  {
    key = "LeftArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bb" }),
  },
  {
    key = "RightArrow",
    mods = "CMD",
    action = wezterm.action({ SendString = "\x1bOF" }),
  },
  {
    key = "RightArrow",
    mods = "OPT",
    action = wezterm.action({ SendString = "\x1bf" }),
  },
}

-- Finally, return the configuration to wezterm:
return config
