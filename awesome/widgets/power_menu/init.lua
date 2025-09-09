local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local menu_builder = require("modules.menu_builder")

local menu_items = {
  { "󰍃 Log Out", function()
    awesome.quit()
  end },
  { " Lock", function()
    awful.spawn("xautolock -locknow")
  end },
  { " Reboot", function()
    awful.spawn("loginctl reboot")
  end },
  { "󰒲 Suspend", function()
    awful.spawn("loginctl suspend")
  end },
  { "⏻ Shutdown", function()
    awful.spawn("loginctl poweroff")
  end },
}

local close_key = { "Mod4", "p" }
local menu = menu_builder(menu_items)
return menu

--return awful.menu {
--  items = menu_items,
--  theme = {
--    width = 400,
--  }
--}
