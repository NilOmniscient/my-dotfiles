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
	awful.spawn("thunar")
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
		awful.spawn("betterlockscreen -l")
	end
end
apps.reboot = function()
	awful.spawn("systemctl reboot")
end
apps.shutdown = function()
	awful.spawn("systemctl poweroff")
end
apps.sleep = function()
	awful.spawn("systemctl suspend")
end

apps.leave = function()
	awesome.quit()
end

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
