local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local watch_fields = {
	[1] = "status",
	[2] = "xesam:artist",
	[3] = "xesam:title",
}

local watch_cmd = string.format("playerctl -f '{{%s}}' metadata", table.concat(watch_fields, "}};{{"))

local trim = function(s)
  if s == nil then
    return ""
  end
  return s:match("^%s*(.-)%s*$")
end

local pause_button = wibox.widget{
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.widget.textbox,
    text = "󰐎",
    buttons = awful.button({}, 1, nil, function()
      awful.spawn("playerctl play-pause")
    end)
  }
}

local player, timer = awful.widget.watch({ awful.util.shell, "-c", watch_cmd }, 0.3, function(widget, stdout)
	local words = gears.string.split(stdout, ";")

  local metadata = {}
  local status, artist, title = trim(words[1]), trim(words[2]), trim(words[3])
  if status ~= "" then table.insert(metadata, status) end
  if artist ~= "" then table.insert(metadata, artist) end
  if title ~= "" then table.insert(metadata, title) end
	local contents = table.concat(metadata, " | ")
  local text = ""
  if contents ~= "" then
    text = "\t" .. " || " .. table.concat(metadata, " | ") .. " || "
    text = text .. "\t"
  end
  widget:set_text(text)
end)

return wibox.widget({
  -- pause_button,
  player,
  layout = wibox.layout.align.horizontal
})
