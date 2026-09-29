local awful = require("awful")
local wibox = require("wibox")

local module = require(... .. ".module")

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			{
				widget = wibox.container.place,
				valign = "center",
			},
			{
				widget = wibox.container.place,
				valign = "center",
			},
			{
				widget = wibox.container.place,
				valign = "center",
			},
		},
	})
end
