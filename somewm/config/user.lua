local awful = require("awful")

-- Input settings

local settings = {
	-- Primary Monitor
	primary_output = "DP-3",

	-- Default Apps
	browser = "firefox-bin",
	file_browser = "thunar",
	editor = os.getenv("EDITOR") or "nvim",
	terminal = "ghostty",

	-- Power control commands
	reboot = "loginctl reboot",
	shutdown = "loginctl poweroff",
	sleep = "loginctl suspend",

	-- Default ModKey
	modkey = "Mod4",

	-- Default Layouts and Tags
	tags = { "1", "2", "3" },
	layouts = {
		awful.layout.suit.floating,
		awful.layout.suit.tile,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.carousel,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.max,
		awful.layout.suit.corner.nw,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
	},
	enable_titlebars = false,
	autostart = {
		"nm-applet",
	},
	autostart_once = {},
}

local success, user_defined = pcall(require, "config.user_defined")
if not success then
	user_defined = {}
end
return settings
