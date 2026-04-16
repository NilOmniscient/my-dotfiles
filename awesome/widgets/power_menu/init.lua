local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")
local apps = require("config.apps")

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
			awful.spawn.with_shell(apps.locker)
		end,
	},
	{
		" Reboot",
		function()
			awful.spawn(apps.reboot)
		end,
	},
	{
		"󰒲 Sleep",
		function()
			awful.spawn(apps.sleep)
		end,
	},
	{
		"⏻ Shutdown",
		function()
			awful.spawn(apps.shutdown)
		end,
	},
}

local close_key = { "Mod4", "p" }
local menu = menu_builder(menu_items)
return menu
