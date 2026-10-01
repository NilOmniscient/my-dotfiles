local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local now_playing = {
	{
		text = " 󰝚 ",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	awful.widget.watch("playerctl metadata --format '{{ artist }} - {{ title }}'", 5, function(widget, stdout)
		local track = stdout:gsub("\n", "")
		if track == "" then
			widget:set_text("Nothing Playing")
		else
			widget:set_text(track)
		end
	end),

	spacing = beautiful.widget_spacing,
	layout = wibox.layout.fixed.horizontal,
}

return now_playing
