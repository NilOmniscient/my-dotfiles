local gears = require("gears")
local awful = require("awful")

local watch_fields = {
  [1] = 'status',
  [2] = 'xesam:artist',
  [3] = 'xesam:title',
  [4] = 'mpris:artUrl',
  [5] = 'position',
  [6] = 'mpris:length',
  [7] = 'album',
  [8] = 'xesam:contentCreated',
}

local watch_cmd = string.format("playerctl -f '{{%s}}' metadata", table.concat(watch_fields, '}};{{'))

local player, timer = awful.widget.watch(
    { awful.util.shell, "-c", watch_cmd },
    0.3,
    function(widget, stdout)
      local words = gears.string.split(stdout, ';')
      local position, length, progress = tonumber(words[5]), tonumber(words[6])
      if position ~= nil and length ~= nil and length > 0 then
        progress = position / length
      end

      local metadata = {
        status = words[1],
        artist = words[2],
        current = words[3],
        art_url = words[4],
        position = position,
        length = length,
        album = words[7],
        progress = string.format("%.0f %%", progress * 100),
      }
      if words[8] ~= nil then
        metadata.year = string.sub(words[8], 0, 4)
      end
      local icon_text = ""
      if metadata.status == "Playing"
      then 
        icon_text = ""
      end
      widget:set_text(icon_text .. " || " .. metadata.current .. " | " .. metadata.artist .. " | " .. metadata.album .." || " .. metadata.progress)
    end
)

return player
