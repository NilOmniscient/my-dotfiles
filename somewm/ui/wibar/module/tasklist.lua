local awful = require("awful")
local wibox = require("wibox")

local task_filter = function(c, screen)
	return c.active
end
return function(s)
	return awful.widget.tasklist({
		screen = s,
		filter = task_filter,
		buttons = {},
		widget_template = {
			{
				{
					{
						{
							{
								id = "icon_role",
								widget = wibox.widget.imagebox,
							},
							margins = 2,
							widget = wibox.container.margin,
						},
						{
							id = "text_role",
							widget = wibox.widget.textbox,
						},
						layout = wibox.layout.fixed.horizontal,
					},
					left = 10,
					right = 10,
					widget = wibox.container.margin,
				},
				id = "background_role",
				widget = wibox.container.background,
			},
			strategy = "max",
			width = 200,
			widget = wibox.container.constraint,
		},
	})
end
