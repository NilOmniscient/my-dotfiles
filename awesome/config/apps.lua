local gears = require("gears")
local lockscreen = gears.filesystem.get_configuration_dir() .. "assets/screensaver.png"
-- This is used later as the default terminal and editor to run.
local apps = {}
apps.browser = "firefox"
apps.editor = os.getenv("EDITOR") or "nvim"
apps.file_browser = "pcmanfm-qt"
apps.launcher = "rofi -show drun"
apps.terminal = "ghostty"
apps.window_switcher = "rofi -show window"

-- These change based on SomeWM status
apps.locker = "lxqt-leave --lockscreen"
apps.reboot = "lxqt-leave --reboot"
apps.shutdown = "lxqt-leave --shutdown"
apps.sleep = "lxqt-leave --suspend"

local is_somewm = awesome.release == "somewm"
if is_somewm then
	apps.locker = "swaylock -i " .. lockscreen
	apps.reboot = "systemctl reboot"
	apps.shutdown = "systemctl poweroff"
	apps.sleep = "systemctl suspend"
end
-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
