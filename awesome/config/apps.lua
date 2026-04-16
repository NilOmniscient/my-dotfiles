local awful = require("awful")
local gears = require("gears")
local lockscreen = gears.filesystem.get_configuration_dir() .. "assets/screensaver.png"
-- This is used later as the default terminal and editor to run.
local apps = {}
apps.browser = function()
	awful.spawn("firefox")
end
apps.editor = function()
	awful.spawn(os.getenv("EDITOR") or "nvim")
end
apps.file_browser = function()
	awful.spawn("pcmanfm-qt")
end
apps.launcher = function()
	awful.spawn("rofi -show drun")
end
apps.terminal = function()
	awful.spawn("ghostty")
end
apps.window_switcher = function()
	awful.spawn("rofi -show window")
end

-- These change based on SomeWM status
local is_somewm = awesome.release == "somewm"
apps.locker = function()
	if is_somewm then
		-- awful.spawn("swaylock -i " .. lockscreen)
		awesome.lock()
	else
		awful.spawn("lxqt-leave --lockscreen")
	end
end
apps.reboot = function()
	if is_somewm then
		awful.spawn("systemctl reboot")
	else
		awful.spawn("lxqt-leave --reboot")
	end
end
apps.shutdown = function()
	if is_somewm then
		awful.spawn("systemctl poweroff")
	else
		awful.spawn("lxqt-leave --shutdown")
	end
end
apps.sleep = function()
	if is_somewm then
		awful.spawn("systemctl suspend")
	else
		awful.spawn("lxqt-leave --suspend")
	end
end

apps.leave = function()
	if is_somewm then
		awesome.quit()
	else
		awful.spawn("lxqt-leave --logout")
	end
end

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
