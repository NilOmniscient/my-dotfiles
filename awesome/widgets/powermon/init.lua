local awful = require("awful")
local gears = require("gears")
local theme = require("beautiful")
local wibox = require("wibox")

local f = io.open("/sys/class/power_supply/BAT0/present", "r")
local present = f:read("*all")
f:close()

if string.find(present, "0") then
  return {}
end

-- If we got here, then there's a battery. 
local powermon = wibox.widget {
  widget = wibox.widget.textbox,
  text = "",
  font = theme.font,
}
function trim(s)
  return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

local function update_power_monitor()
  awful.spawn.easy_async_with_shell("acpi | cut -d, -f 1 | cut -d: -f 2", function(status)
    if trim(status) == "Charging" then
      powermon:set_text(" 󰂄 ")
    else
      awful.spawn.easy_async_with_shell("acpi | cut -d, -f 2 | cut -d% -f 1", function(level)
        local states = {
          [1] = " 󰁺 ",
          [2] = " 󰁻 ",
          [3] = " 󰁼 ",
          [4] = " 󰁽 ",
          [5] = " 󰁾 ",
          [6] = " 󰁿 ",
          [7] = " 󰂀 ",
          [8] = " 󰂁 ",
          [9] = " 󰂂 ",
        }

        -- Compare power to determine image
        local index = math.floor(tonumber(level) / 10) + 1
        if index < 1 then index = 1 end
        if index > 9 then index = 9 end

        powermon:set_text(states[index] .. " " .. tonumber(level) .. "% ")
      end)
    end
  end)
end

gears.timer {
  timeout = 10,
  call_now = true,
  autostart = true,
  callback = update_power_monitor,
}

return powermon
