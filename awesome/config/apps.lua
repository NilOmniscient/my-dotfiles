-- This is used later as the default terminal and editor to run.
local apps = {}
apps.terminal = "ghostty"
apps.editor = os.getenv("EDITOR") or "nvim"
apps.editor_cmd = apps.terminal .. " -e " .. apps.editor
apps.browser = "firefox"
apps.file_browser = "thunar"

-- Set the terminal for the menubar.
require("menubar").utils.terminal = apps.terminal

return apps
