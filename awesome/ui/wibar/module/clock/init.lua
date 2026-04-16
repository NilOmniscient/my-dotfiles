local wibox = require("wibox")
local final_widget = {
	layout = wibox.layout.fixed.horizontal,
	{
		widget = wibox.container.margin,
		right = 8,
		wibox.widget.textbox("  "),
	},
	{
		widget = wibox.container.margin,
		right = 16,
		wibox.widget.textclock("%I:%M %P"),
	},
}
return final_widget
