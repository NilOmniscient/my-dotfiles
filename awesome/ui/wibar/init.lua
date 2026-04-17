local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local screen = require("screen")
local beautiful = require("beautiful")
local module = require("ui.wibar.module")
local media_player = require("ui.wibar.module.media_player")

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
	local text_clock = module.clock
	local right_widgets = {}
	if s == screen.primary then
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

	local center_widget = {
		layout = wibox.layout.fixed.horizontal,
		spacing = 2,
		spacing_widget = wibox.widget.separator,
		{
			widget = wibox.container.margin,
			-- media_summary,
			module.media_player,
		},
		{
			widget = wibox.container.margin,
			module.clock,
		},
		{
			widget = wibox.container.margin,
			module.notifications,
		},
	}

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
			-- wrap_widget({
			--	layout = wibox.layout.fixed.horizontal,
			--	module.media_player,
			-- }),
			wrap_widget(center_widget),
			-- Right widgets.
			wrap_widget(right_widgets),
		},
	})
end
