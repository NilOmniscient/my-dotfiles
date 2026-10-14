local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

-- Required modules
local notifications = require("module.notifications")

local notification_widget = wibox.widget({
	{
		id = "bell_icon",
		font = beautiful.font,
		text = "󰂚",
		widget = wibox.widget.textbox,
	},
	widget = wibox.container.place,
	valign = "center",
})

local function set_badge()
	local bell_icon = notification_widget:get_children_by_id("bell_icon")[1]
	local count = notifications.unread_count or 0

	if notifications.dnd_mode == true then
		bell_icon.text = "󰂛"
	else
		if count > 0 then
			bell_icon.text = "󱅫"
		else
			bell_icon.text = "󰂚"
		end
	end
end

notification_widget:add_button(awful.button({}, 1, function()
	notifications.toggle_notification_center()
end))

notification_widget:connect_signal("notification:unread_count", function()
	set_badge()
end)
notification_widget:connect_signal("notification:dnd_changed", function()
	set_badge()
end)

return notification_widget
