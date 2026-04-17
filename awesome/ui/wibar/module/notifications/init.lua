local awful = require("awful")
local wibox = require("wibox")
local notifications = require("module.notifications")
local final_widget = wibox.widget({
	widget = wibox.widget.textbox,
	text = " 󰇯 ",
})

local update_icon = function()
	if notifications.unread_count and notifications.unread_count > 0 then
		final_widget:set_text(" 󰛏 ")
	else
		final_widget:set_text(" 󰇯 ")
	end
end

awesome.connect_signal("notification:unread_count", function(count)
	update_icon()
end)

final_widget:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
	notifications.toggle_notification_center()
end)))

return final_widget
