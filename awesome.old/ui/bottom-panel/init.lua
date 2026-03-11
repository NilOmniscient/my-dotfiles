local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

configuration = require("configuration.config")
require("widgets.top-panel")

local BottomPanel = function(s)
	local panel = awful.wibar({
    position = "bottom",
    ontop = true,
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.transparent,
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

	panel:setup({
		layout = wibox.layout.align.horizontal,
		expand = "none",
		left_widgets,
		middle_widgets,
		right_widgets,
	})

	return panel
end

return BottomPanel
