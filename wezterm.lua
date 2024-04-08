local wezterm = require("wezterm")

local c = {}

wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window{}
  window:gui_window():maximize()
end)

c.font = wezterm.font({
  family="JetBrainsMono Nerd Font Mono",
})

local reproduce_script
-- reproduce_script = '<PATH_TO_DIR>/reproduce.sh <ARGS>'
reproduce_script = 'reproduce.sh'
-- reproduce_script = 'reproduce.sh --line-prefix ""'
-- reproduce_script = 'reproduce.sh --timeout 60'
-- reproduce_script = 'reproduce.sh --print-inline'


c.default_prog = { 'bash', '-c', reproduce_script }
return c
