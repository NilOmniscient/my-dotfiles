local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Detect which volume control command to use
local function get_volume_cmd()
	return [[
    if command -v pamixer >/dev/null 2>&1; then
      pamixer --get-volume
    elif command -v wpctl >/dev/null 2>&1; then
      wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2 * 100)}'
    else
      echo "0"
    fi
  ]]
end

local function get_mute_cmd()
	return [[
    if command -v pamixer >/dev/null 2>&1; then
      pamixer --get-mute
    elif command -v wpctl >/dev/null 2>&1; then
      wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED" && echo "true" || echo "false"
    else
      echo "false"
    fi
  ]]
end

-- SomeWM uses icons, I use Nerd Fonts
local volume_widget = wibox.widget({
	{
		id = "icon",
		widget = wibox.widget.textbox,
	},
	{
		id = "text",
		widget = wibox.widget.textbox,
	},
	spacing = beautiful.widget_icon_spacing,
	layout = wibox.layout.fixed.horizontal,
})

volume_widget.tooltip = awful.tooltip({
	objects = { volume_widget },
})

-- Which of the four icons matches this volume level
local function level_icon(volume_level, muted)
	if muted or volume_level == 0 then
		return ""
	elseif volume_level <= 25 then
		return "󰕿"
	elseif volume_level <= 75 then
		return "󰖀"
	else
		return "󰕾"
	end
end

local function update_volume()
	awful.spawn.easy_async_with_shell(get_volume_cmd(), function(vol)
		-- INFO: This stdout contains a \n character that messes up how the tooltip looks.
		local vol_string = string.gsub(vol, "\n", "")

		-- If there is no audio sink at all (a VM, a nested test instance, a machine with
		-- PipeWire down) the command above prints nothing, and tonumber gives back nil.
		-- Every comparison below would then throw, so pin it to a number here.
		local volume_level = tonumber(vol_string) or 0

		volume_widget:get_children_by_id("text")[1].text = volume_level .. "%"
		volume_widget.tooltip.text = volume_level .. "%"

		--INFO: The way pamixer works, if you increase volume, it does not break `mute`.  So I want to update the tooltip, but not the icon, that's why I have it nested instead of a separate function.
		awful.spawn.easy_async_with_shell(get_mute_cmd(), function(mute)
			local muted = string.find(mute, "true") ~= nil
			volume_widget:get_children_by_id("icon")[1].text = level_icon(volume_level, muted)
		end)
	end)
end

update_volume()

awesome.connect_signal("volume::update", function()
	update_volume()
end)

return volume_widget
