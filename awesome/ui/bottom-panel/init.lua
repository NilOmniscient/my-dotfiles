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
		y = s.geometry.height - configuration.toppanel_height,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		struts = {
			bottom = configuration.toppanel_height,
		},
	})

	panel:struts({
	  bottom = configuration.toppanel_height,
	})
	--

	panel:setup({
		layout = wibox.layout.align.horizontal,
    expand = "none",
		s.mytasklist, -- Middle widget
	})

	return panel
end

return BottomPanel
