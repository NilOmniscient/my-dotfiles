local awful = require("awful")
local user = require("config.user")
local apps = {
	browser = function()
		awful.spawn(user.browser)
	end,
	editor = function()
		awful.spawn(user.editor)
	end,
	file_browser = function()
		awful.spawn(user.file_browser)
	end,
	terminal = function()
		awful.spawn(user.terminal)
	end,
	locker = function()
		awesome.lock()
	end,
	reboot = function()
		awful.spawn(user.reboot)
	end,
	shutdown = function()
		awful.spawn(user.shutdown)
	end,
	suspend = function()
		awful.spawn(user.suspend)
	end,
	leave = function()
		awesome.quit()
	end,
}

return apps
