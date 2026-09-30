local awful = require("awful")
local theme = require("beautiful")
local wibox = require("wibox")

-- Local
local widgets = require("widgets")
local modules = require("ui.wibar.module")

local spacer = {
	text = " ",
	widget = wibox.widget.textbox,
}

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
				nil,
				{
					widgets.notification,
					widgets.clock,
					spacing = theme.widget_spacing,
					layout = wibox.layout.fixed.horizontal,
				},
				nil,
				expand = "none",
				layout = wibox.layout.align.horizontal,
			},
			{
				nil,
				nil,
				{
					s == screen.primary and wibox.widget.systray() or nil,
					widgets.volume,
					widgets.dashboard,
					spacer,
					spacing = theme.widget_spacing,
					layout = wibox.layout.fixed.horizontal,
				},
				layout = wibox.layout.align.horizontal,
			},
		},
	})
end
