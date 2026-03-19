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

	local text_clock = wibox.widget.textclock(" %b %d, %I:%M %P")
	local right_widgets = {}
	if s.index == 1 then
		right_widgets = wibox.widget({
			layout = wibox.layout.fixed.horizontal,
			awful.widget.keyboardlayout(), -- Keyboard map indicator and switcher.
			wibox.widget.systray(),
			text_clock,
		})
	else
		right_widgets = wibox.widget({
			layout = wibox.layout.fixed.horizontal,
			awful.widget.keyboardlayout(), -- Keyboard map indicator and switcher.
			text_clock,
		})
	end
	-- Create the wibox
	s.mywibox = awful.wibar({
		layout = wibox.layout.fixed.horizontal,
		position = "top",
		screen = s,
		height = beautiful.panel_height or 34,
		bg = beautiful.transparent,
		fg = beautiful.fg_normal,
		widget = {
			layout = wibox.layout.align.horizontal,
			expand = "none",
			width = s.geometry.width,
			-- Left widgets.
			wrap_widget({
				layout = wibox.layout.fixed.horizontal,
				module.layoutbox(s),
				-- module.launcher(),
				module.taglist(s),
				s.mypromptbox,
			}),
			-- Middle Widgets.
			wrap_widget({
				layout = wibox.layout.fixed.horizontal,
				module.media_player,
			}),
			-- Right widgets.
			wrap_widget(right_widgets),
		},
	})
end
