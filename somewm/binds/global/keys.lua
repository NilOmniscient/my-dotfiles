local awesome = require("awesome")
local awful = require("awful")
local mod = require("binds.mod")
local modkey = mod.modkey
local ctrl = mod.ctrl
local shift = mod.shift

local apps = require("config.apps")
local launcher = require("widgets.launcher")

local helper = require("binds.helpers").table_to_bindings
local global_helpers = {
	media_next = function()
		awful.spawn("playerctl next")
	end,
	media_prev = function()
		awful.spawn("playerctl previous")
	end,
	media_play = function()
		awful.spawn("playerctl play-pause")
	end,
	media_stop = function()
		awful.spawn("playerctl stop")
	end,
	vol_mute = function()
		awful.spawn("amixer set Master toggle")
	end,
	vol_up = function()
		awful.spawn("amixer set Master 5%+")
	end,
	vol_down = function()
		awful.spawn("amixer set Master 5%-")
	end,
}

local bindings_table = {
	-- SomeWM bindings
	{ { modkey, ctrl }, "r", awesome.restart, "Restart SomeWM", group = "somewm" },
	{ { modkey, shift }, "q", awesome.quit, "Quit SomeWM", group = "somewm" },

	-- Launchers
	{ { modkey }, "r", launcher.show, "Application Launcher", "launcher" },
	{ { modkey }, "Return", apps.terminal, "Launch Terminal", "launcher" },
	{ { modkey }, "b", apps.browser, "Launch Browser", "launcher" },
	{ { modkey }, "f", apps.file_browser, "Launch File Browser" },

	-- Media Keys
	{ {}, "XF86AudioNext", global_helpers.media_next, "Next Media Track", "media" },
	{ {}, "XF86AudioPrev", global_helpers.media_prev, "Prev Media Track", "media" },
	{ {}, "XF86AudioPlay", global_helpers.media_play, "Play/Pause Media", "media" },
	{ {}, "XF86AudioStop", global_helpers.media_stop, "Stop Media Track", "media" },

	-- Volume Keys
	{ {}, "XF86AudioMute", global_helpers.vol_mute, "Mute Volume", "volume" },
	{ {}, "XF86AudioRaiseVolume", global_helpers.vol_up, "Raise Volume", "volume" },
	{ {}, "XF86AudioLowerVolume", global_helpers.vol_down, "Lower Volume", "volume" },
}

-- For now, just do the basic commands that don't need extra modules
awful.keyboard.append_global_keybindings(helper(bindings_table))
