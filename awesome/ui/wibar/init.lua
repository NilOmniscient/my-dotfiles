local awful = require("awful")
local wibox = require("wibox")

-- Local
local widgets = require("widgets")
local modules = require("ui.wibar.module")

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.flex.horizontal,
			{
				modules.tasklist(s),
				layout = wibox.layout.fixed.horizontal,
			},
			{
				widgets.clock,
				layout = wibox.layout.flex.horizontal,
			},
			{
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
		},
	})
end
