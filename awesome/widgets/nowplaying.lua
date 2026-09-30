local beautiful = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")

-- Load the LGI bindings
local lgi = require("lgi")
local playerctl = lgi.Playerctl

local manager = playerctl.PlayerManager()

local now_playing = {
	{
		text = "󰝚",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	{
		id = "text",
		font = beautiful.font,
		text = "",
		widget = wibox.widget.textbox,
	},
	{
		text = "󰝚",
		font = beautiful.font,
		widget = wibox.widget.textbox,
	},
	layout = wibox.layout.flex.horizontal,
}

local function update_widget()
	local player = manager.active_player
	local metadata = player.metadata
	local status = player.playback_status

	if status == "PLAYING" and metadata then
		local title = metadata["xesam:title"] or "Unknown Title"
		local artist = metadata["xesam:artist"]
		if type(artist) == "table" or (type(artist) == "userdata" and artist[1]) then
			artist = artist[1]
		else
			artist = artist or "Unknown Artist"
		end
		now_playing:get_children_by_id("text")[1].text = artist .. " - " .. title
	else
		now_playing:get_children_by_id("text")[1].text = "No Playback"
	end
end

manager:connect("active-player-changed", function(_, active_player)
	update_widget()
	if active_player then
		active_player.on_playback_status = function()
			update_widget()
		end
		active_player.on_metadata = function()
			update_widget()
		end
	end
end)

return now_playing
