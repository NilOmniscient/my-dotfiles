local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local menu_builder = require("module.menu_builder")

local menu_items = {
	{
		"󰍃 Log Out",
		function()
			awesome.quit()
		end,
	},
	{
		" Lock",
		function()
			awful.spawn.with_shell("xflock4")
		end,
	},
	{
		" Reboot",
		function()
			awful.spawn("systemctl reboot")
		end,
	},
	{
		"󰒲 Sleep",
		function()
			awful.spawn("systemctl sleep")
		end,
	},
	{
		"⏻ Shutdown",
		function()
			awful.spawn("systemctl poweroff")
		end,
	},
}

local close_key = { "Mod4", "p" }
local menu = menu_builder(menu_items)
return menu
