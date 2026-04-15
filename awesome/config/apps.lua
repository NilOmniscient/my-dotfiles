-- This is used later as the default terminal and editor to run.
local apps = {}
apps.browser = "firefox"
apps.editor = os.getenv("EDITOR") or "nvim"
apps.file_browser = "pcmanfm-qt"
apps.launcher = "xfce4-appfinder"
apps.terminal = "ghostty"

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
