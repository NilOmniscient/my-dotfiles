-- awesome_mode: api-level=4:screen=on
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Autostart things that need to be run
require("autostart")

-- Before anything else, include the display config
-- require("config.display")
--- Error handling.
-- Notification library.
local naughty = require("naughty")
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config).
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- Allow Awesome to automatically focus a client upon changing tags or loading.
require("awful.autofocus")
-- Enable hotkeys help widget for VIM and other apps when client with a matching
-- name is opened:
require("awful.hotkeys_popup.keys")

-- Load the theme. In other words, defines the variables within the `beautiful`
-- table.
-- require("theme.default")
require("theme.catppuccin")

-- Treat all signals. Bear in mind this implies creating all tags, attaching
-- their layouts, setting client behavior and loading UI.
require("signal")

-- Set all keybinds.
require("binds")

-- Load all client rules.
require("config.rules")

-- Replace Awful.Snap with a better snapping module
local awful = require("awful")

local is_somewm = awesome.release == "somewm"
if is_somewm then
else
	local snapgap = require("module.snapgap")
	snapgap.snap.edge_enabled = true
	awful.mouse.snap.edge_enabled = false
	awful.mouse.snap.client_enabled = false
end

-- Finally, make the garbage collector more aggressive.
local gears = require("gears")
gears.timer.start_new(600, function()
	collectgarbage("step", 1024)
	return true
end)
