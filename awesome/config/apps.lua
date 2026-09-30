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

-- Quick helper for determining if we're on a systemctl or loginctl system
local function get_ctl_cmd()
	return [[
    if command -v systemctl >/dev/null 2>&1; then
      systemctl
    elif command -v loginctl >/dev/null 2>&1; then
      loginctl
    else
      echo "0"
    fi
  ]]
end

local systemctl = get_ctl_cmd()
if systemctl ~= 0 then
	apps.poweroff = systemctl .. " poweroff"
	apps.suspend = systemctl .. " suspend"
	apps.reboot = systemctl .. " reboot"
end

return apps
