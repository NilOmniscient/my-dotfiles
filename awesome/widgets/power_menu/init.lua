local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local menu_items = {
  { "󰍃 Log Out", function() awesome.quit() end },
  { " Lock", "xautolock -locknow" },
  { " Reboot", "loginctl reboot" },
  { "󰒲 Suspend", "loginctl suspend" },
  { "⏻ Shutdown", "loginctl poweroff" },
}

return awful.menu {
  items = menu_items,
  theme = {
    width = 400,
  }
}
