local awful = require("awful")
local theme = require("beautiful")
local wibox = require("wibox")

local modules = require("ui.wibar.module.dashboard.modules")

local dashboard = wibox.widget({
	{
		{
			text = " 󰕮 Dashboard ",
			font = theme.font,
			widget = wibox.widget.textbox,
		},
		margins = 4,
		layout = wibox.container.margin,
	},
	widget = wibox.container.background,
})

local dashboard_popup = awful.popup({
	ontop = true,
	visible = false,
	border_width = 1,
	border_color = theme.bg_focus,
	maximum_width = 400,
	minimum_width = 200,
	offset = { y = 5 },
	widget = {
		layout = wibox.layout.fixed.vertical,
		spacing = 1,
		spacing_widget = wibox.widget.separator,
		modules.profile.create(),
		modules.sliders.create(),
		modules.toggles.create(),
		modules.calendar.create(),
	},
})

-- Before returning the widget, make sure to let the popup show.
dashboard:buttons(awful.util.table.join(awful.button({}, 1, function()
	if dashboard_popup.visible then
		dashboard_popup.visible = not dashboard_popup.visible
	else
		dashboard_popup:move_next_to(mouse.current_widget_geometry)
	end
end)))

return dashboard
