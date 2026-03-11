local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local module = require(... .. ".module")

local wrap_widget = function(w)
	local wrapped = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
		{
			{
				w,
				top = 2,
				bottom = 2,
				left = 10,
				right = 10,
				color = beautiful.bg_normal,
				widget = wibox.container.margin,
			},
			bg = beautiful.bg_normal,
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
			shape_border_width = 2,
			shape_border_color = beautiful.bg_focus,
		},
	})
	return wrapped
end

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.

	-- Create the wibox
	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.align.horizontal,
			-- Left widgets.
			wrap_widget({
				layout = wibox.layout.fixed.horizontal,
				module.layoutbox(s),
				-- module.launcher(),
				module.taglist(s),
				s.mypromptbox,
			}),
			-- Middle widgets.
			wibox.widget({
				layout = wibox.layout.fixed.horizontal,
			}),
			-- Right widgets.
			wrap_widget({
				layout = wibox.layout.fixed.horizontal,
				awful.widget.keyboardlayout(), -- Keyboard map indicator and switcher.
				wibox.widget.systray(),
				wibox.widget.textclock(), -- Create a textclock widget.
			}),
		},
	})
end
