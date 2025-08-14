local gears = require("gears")
local awful = require("awful")

local watch_fields = {
	[1] = "status",
	[2] = "xesam:artist",
	[3] = "xesam:title",
	[4] = "mpris:artUrl",
	[5] = "position",
	[6] = "mpris:length",
	[7] = "album",
	[8] = "xesam:contentCreated",
}

local watch_cmd = string.format("playerctl -f '{{%s}}' metadata", table.concat(watch_fields, "}};{{"))

local player_widget = {}
-- Player requires:
-- Source Selector
-- Control buttons
-- Metadata
-- Volume?

local trim = function(s)
  if s == nil then
    return ""
  end
  return s:match("^%s*(.-)%s*$")
end



local player, timer = awful.widget.watch({ awful.util.shell, "-c", watch_cmd }, 0.3, function(widget, stdout)
	local words = gears.string.split(stdout, ";")

	local position, length, progress = tonumber(words[5]), tonumber(words[6])
	if position ~= nil and length ~= nil and length > 0 then
		progress = string.format("%.0f %%", (position / length) * 100)
	end

  local metadata = {}
  local status, artist, title, album, year = trim(words[1]), trim(words[2]), trim(words[3]), trim(words[7]), trim(words[8])
  if status ~= "" then table.insert(metadata, status) end
  if artist ~= "" then table.insert(metadata, artist) end
  if title ~= "" then table.insert(metadata, title) end
  if album ~= "" then table.insert(metadata, album) end
  if year ~= "" then
    table.insert(metadata, string.sub(year, 0, 4))
  end
	local icon_text = ""
	if metadata.status == "Playing" then
		icon_text = ""
	end
	local text = "\t" .. icon_text .. " || " .. table.concat(metadata, " | ") .. " || " .. progress .. "\t"
	widget:set_text(text)
end)

return player
