local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local menu_builder = require("module.menu_builder")

local menu_items = {
	{
		"󰍃 Log Out",
		function()
			awful.spawn.with_shell("xfce4-session-logout --logout")
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
			awful.spawn("xfce4-session-logout --reboot")
		end,
	},
	{
		"󰒲 Sleep",
		function()
			awful.spawn("xfce4-session-logout --susspend")
		end,
	},
	{
		"⏻ Shutdown",
		function()
			awful.spawn("poweroff")
		end,
	},
}

local close_key = { "Mod4", "p" }
local menu = menu_builder(menu_items)
return menu
