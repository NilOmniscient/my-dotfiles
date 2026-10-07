local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")

local is_somewm = awesome.release == "somewm"

local idle_icon = wibox.widget({
	font = beautiful.font,
	text = "",
	widget = wibox.widget.textbox,
})

if is_somewm then
	idle_icon:add_button(awful.button({}, awful.button.names.LEFT, function()
		-- First, check if any clients are fullscreen.
		local dominated = false
		for _, c in ipairs(client.get()) do
			if c.fullscreen then
				dominated = true
				break
			end
		end
		if not dominated then
			awesome.idle_inhibit = not awesome.idle_inhibit
		end
	end))
	local function update_idle_icon()
		idle_icon.text = awesome.idle_inhibited and " 󰅶 " or " 󰛊 "
	end
	awesome.connect_signal("property::idle_inhibited", update_idle_icon)
	update_idle_icon()
end

return idle_icon
