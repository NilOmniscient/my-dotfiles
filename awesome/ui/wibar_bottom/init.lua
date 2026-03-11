local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local module = require(... .. ".module")

local empty = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
})
return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		height = beautiful.panel_height or 34,
		position = "bottom",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			expand = "none",
			-- Left widgets.
			empty,
			-- Middle widgets.
			module.tasklist(s),
			-- Right widgets.
			empty,
		},
	})
end
