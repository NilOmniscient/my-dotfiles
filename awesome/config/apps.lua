-- This is used later as the default terminal and editor to run.
local apps = {}
apps.terminal = "ghostty"
apps.editor = os.getenv("EDITOR") or "vi"
apps.editor_cmd = apps.terminal .. " -e " .. apps.editor

-- Some other apps, e.g. Browser, File Browser, and Launcher
apps.launcher = "xfce4-appfinder"
apps.browser = "firefox"
apps.file_browser = "dolphin"

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
