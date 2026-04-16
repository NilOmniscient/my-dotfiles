local gears = require("gears")
local lockscreen = gears.filesystem.get_configuration_dir() .. "assets/screensaver.png"
-- This is used later as the default terminal and editor to run.
local apps = {}
apps.browser = "firefox"
apps.editor = os.getenv("EDITOR") or "nvim"
apps.file_browser = "pcmanfm-qt"
apps.launcher = "rofi -show drun"
apps.locker = "swaylock -i " .. lockscreen
apps.terminal = "ghostty"
apps.window_switcher = "rofi -show window"

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
