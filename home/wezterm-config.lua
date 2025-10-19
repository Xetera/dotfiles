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

local function scheme_for_appearance(app)
  if app:find("Dark") then
    return "Catppuccin Mocha"
  else
    return "Catppuccin Latte"
  end
end

local config = wezterm.config_builder()
bar.apply_to_config(config)

config.initial_cols = 120
config.initial_rows = 28

local appearance = get_appearance()
config.font_size = 14
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.scrollback_lines = 100000
config.color_scheme = scheme_for_appearance(appearance)
config.window_decorations = "RESIZE"

local function window_frame(app)
  local sky = "#04a5e5"
  local peach = "#5b6078"
  if app:find("Dark") then
    return {
      border_left_width = "0.4cell",
      border_right_width = "0.4cell",
      border_bottom_height = "0.2cell",
      border_top_height = "0.2cell",
      border_left_color = peach,
      border_right_color = peach,
      border_bottom_color = peach,
      border_top_color = peach,
    }
  else
    return {
      border_left_width = "0.4cell",
      border_right_width = "0.4cell",
      border_bottom_height = "0.2cell",
      border_top_height = "0.2cell",
      border_left_color = sky,
      border_right_color = sky,
      border_bottom_color = sky,
      border_top_color = sky,
    }
  end
end

-- config.window_frame = window_frame(appearance)

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
