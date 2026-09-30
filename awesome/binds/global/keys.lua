local awful = require("awful")

local mod = require("binds.mod")
local modkey = mod.modkey

local apps = require("config.apps")

-- Import any widgets we need to control
local dashboard = require("module.dashboard")
local windowswitcher = require("module.windowswitcher")
local exitscreen = require("module.exitscreen")
local launcher = require("module.launcher")

-- Convert a table to a proper keybind
local function table_to_keybinding(bindings)
	local key_bindings = {}
	for _, g_key in ipairs(bindings) do
		table.insert(
			key_bindings,
			awful.key(g_key[1], g_key[2], g_key[3], { description = g_key[4], group = g_key[5] })
		)
	end
	return key_bindings
end

local media_helpers = {
	raise_volume = function()
		awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
		awesome.emit_signal("volume::update")
	end,
	lower_volume = function()
		awful.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
		awesome.emit_signal("volume::update")
	end,
	toggle_mute = function()
		awful.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
		awesome.emit_signal("volume::update")
	end,
	next_track = function()
		awful.spawn("playerctl next")
	end,
	prev_track = function()
		awful.spawn("playerctl prev")
	end,
	play_pause = function()
		awful.spawn("playerctl play-pause")
	end,
}
local awesome_helpers = {
	show_menu = function()
		require("ui.menu"):show()
	end,
}
local launchers = {
	terminal = function()
		awful.spawn(apps.terminal)
	end,
	launcher = function()
		awful.spawn(apps.launcher)
	end,
	browser = function()
		awful.spawn(apps.browser)
	end,
	file_browser = function()
		awful.spawn(apps.file_browser)
	end,
}

local global_keys = {
	-- Widget keybinds
	{ { modkey }, "Tab", windowswitcher.show, "Window Switcher", "widgets" },

	-- General Awesome keys
	{ { modkey }, "s", require("awful.hotkeys_popup").show_help, "show help", "awesome" },
	{ { modkey }, "w", awesome_helpers.show_menu, "show main menu", "awesome" },
	{ { modkey, mod.ctrl }, "r", awesome.restart, "reload awesome", "awesome" },
	{ { modkey, mod.shift }, "q", awesome.quit, "quit awesome", "awesome" },
	{ { modkey }, "l", apps.locker, "show lockscreen", "awesome" },
	{ { modkey }, "p", exitscreen.show, "show exit screen", "awesome" },
	{ { modkey }, "r", launcher.show, "show app launcher", "awesome" },
	{ { modkey }, "d", dashboard.toggle, "show dashboard", "awesome" },

	-- Launcher bindings
	{ { modkey }, "Return", launchers.terminal, "open terminal", "launcher" },
	{ { modkey }, "b", launchers.browser, "open web browser", "launcher" },
	{ { modkey }, "f", launchers.file_browser, "open file browser", "launcher" },

	-- Media bindings
	{ {}, "XF86AudioLowerVolume", media_helpers.lower_volume, "decrease volume", "media" },
	{ {}, "XF86AudioRaiseVolume", media_helpers.raise_volume, "increase volume", "media" },
	{ {}, "XF86AudioMute", media_helpers.toggle_mute, "mute volume", "media" },
	{ {}, "XF86AudioNext", media_helpers.next_track, "next track", "media" },
	{ {}, "XF86AudioPlay", media_helpers.play_pause, "play/pause track", "media" },
	{ {}, "XF86AudioPrev", media_helpers.prev_track, "previous track", "media" },
}

--- Global key bindings
awful.keyboard.append_global_keybindings(table_to_keybinding(global_keys))
