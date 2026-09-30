local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- Required modules
local dashboard = require("module.dashboard")
local dashboard_widget = wibox.widget({
	{
		font = beautiful.font,
		text = "󰕮",
		widget = wibox.widget.textbox,
	},
	spacing = beautiful.widget_icon_spacing,
	layout = wibox.layout.fixed.horizontal,
	buttons = {
		awful.button({}, awful.button.names.LEFT, function()
			io.stderr:write("Attempting to open dashboard")
			dashboard.toggle()
		end),
	},
})

return dashboard_widget
