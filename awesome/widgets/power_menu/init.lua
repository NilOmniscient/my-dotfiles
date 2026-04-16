local apps = require("config.apps")

local menu_builder = require("module.menu_builder")

local menu_items = {
	{ "󰍃 Log Out", apps.leave },
	{ " Lock", apps.locker },
	{ " Reboot", apps.reboot },
	{ "󰒲 Sleep", apps.sleep },
	{ "⏻ Shutdown", apps.shutdown },
}

local menu = menu_builder(menu_items)
return menu
