-- awesome_mode: api-level=4:screen=on
local config_dir = require("gears.filesystem").get_configuration_dir()
package.path = config_dir .. "?.lua;" .. config_dir .. "?/init.lua;" .. package.path
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

require("theme")

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

-- Treat all signals. Bear in mind this implies creating all tags, attaching
-- their layouts, setting client behavior and loading UI.
require("signal")

-- Set all keybinds.
require("binds")

-- Load all client rules.
require("config.rules")
