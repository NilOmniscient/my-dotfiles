local awful = require("awful")
local wibox = require("wibox")

-- Local
local widgets = require("widgets")

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			{
				layout = wibox.layout.fixed.horizontal,
			},
			{
				nil,
				-- wibox.widget.textclock(),
				widgets.clock,
				nil,
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
			{
				layout = wibox.layout.align.horizontal,
			},
		},
	})
end
