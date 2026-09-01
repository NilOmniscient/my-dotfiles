local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local theme = require("beautiful")
local module = require("ui.wibar.module")

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
				color = theme.xcolorS0,
				widget = wibox.container.margin,
			},
			bg = theme.xcolorS0,
			widget = wibox.container.background,
			shape = gears.shape.rounded_rect,
			shape_border_width = 2,
			shape_border_color = theme.border_color_active,
		},
	})
	return wrapped
end

return function(s)
	s.mypromptbox = awful.widget.prompt() -- Create a promptbox.
	local right_widgets = {}
	if s == screen.primary or awesome.release == "somewm" then
		local systray = wibox.widget.systray()
		right_widgets = wibox.widget({
			spacing = 1,
			spacing_widget = wibox.widget.separator,
			layout = wibox.layout.fixed.horizontal,
			systray,
			module.dashboard,
		})
	else
		right_widgets = wibox.widget({
			spacing = 1,
			spacing_widget = wibox.widget.separator,
			layout = wibox.layout.fixed.horizontal,
			module.dashboard,
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
		module.clock,
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
		height = theme.panel_height or 34,
		bg = theme.xcolorbase,
		fg = theme.fg_normal,
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
	s.mywibox:struts({
		top = theme.panel_height or 34,
	})
end
