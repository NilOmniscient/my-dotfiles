local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local menu_builder = require("module.menu_builder")

local is_somewm = awesome.release == "somewm"

local menu_items = {
	{
		"󰍃 Log Out",
		function()
			if is_somewm then
				awesome.quit()
			else
				awful.spawn.with_shell("lxqt-leave --logout")
			end
		end,
	},
	{
		" Lock",
		function()
			awful.spawn.with_shell("lxqt-leave --lockscreen")
		end,
	},
	{
		" Reboot",
		function()
			awful.spawn("lxqt-leave --reboot")
		end,
	},
	{
		"󰒲 Sleep",
		function()
			awful.spawn("lxqt-leave --suspend")
		end,
	},
	{
		"⏻ Shutdown",
		function()
			awful.spawn("lxqt-leave --shutdown")
		end,
	},
}

local close_key = { "Mod4", "p" }
local menu = menu_builder(menu_items)
return menu
