local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

configuration = require("configuration.config")
require("widgets.top-panel")

local BottomPanel = function(s)
	-- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code
	local panel = awful.wibar({
    position = "bottom",
    ontop = true,
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = gears.color.change_opacity(beautiful.background, 0.0),
		fg = beautiful.fg_normal,
    strut = {
      bottom = configuration.toppanel_height,
    },
	})
	local left_widgets = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
	})
	local middle_widgets = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
    s.mytasklist
  })
	local right_widgets = wibox.widget({
		layout = wibox.layout.fixed.horizontal,
	})

	local wrap_widget = function(w)
		local wrapped = wibox.widget({
			layout = wibox.layout.fixed.horizontal,
			{
				{
					w,
					top = 2,
					bottom = 2,
					left = 20,
					right = 20,
					color = beautiful.wrapped_fg,
					widget = wibox.container.margin,
				},
				bg = beautiful.wrapped_bg,
				widget = wibox.container.background,
				shape = gears.shape.rounded_rect,
			},
		})
		return wrapped
	end

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		left_widgets,
		wrap_widget(middle_widgets),
		right_widgets,
	})

	return panel
end

return BottomPanel
