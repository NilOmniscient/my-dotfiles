local awful = require("awful")
local theme = require("beautiful")
local wibox = require("wibox")

local calendar = require("ui.wibar.module.clock.modules.calendar")
local clock = wibox.widget({
	{
		layout = wibox.container.margin,
		margins = 2,
		{
			format = "   %I:%M %P ",
			widget = wibox.widget.textclock,
			font = theme.font_sm,
			valign = "center",
			halign = "center",
		},
	},
	widget = wibox.container.background,
})

local clock_popup = awful.popup({
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
		calendar.create(),
	},
})

-- Before returning the widget, make sure to let the popup show.
clock:buttons(awful.util.table.join(awful.button({}, 1, function()
	if clock_popup.visible then
		clock_popup.visible = not clock_popup.visible
	else
		clock_popup:move_next_to(mouse.current_widget_geometry)
	end
end)))

return clock
