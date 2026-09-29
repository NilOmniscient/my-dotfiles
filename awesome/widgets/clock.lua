local beautiful = require("beautiful")
local wibox = require("wibox")

return wibox.widget({
	{
		font = beautiful.font,
		format = " %I:%M %p",
		widget = wibox.widget.textclock,
	},
	widget = wibox.container.place,
	valign = "center",
})
