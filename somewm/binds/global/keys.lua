local awesome = require("awesome")
local awful = require("awful")
local mod = require("binds.mod")
local modkey = mod.modkey
local ctrl = mod.ctrl
local shift = mod.shift
local alt = mod.alt

local apps = require("config.apps")

-- For now, just do the basic commands that don't need extra modules
awful.keyboard.append_global_keybindings({
	-- SomeWM state
	awful.key({ modkey, ctrl }, "r", awesome.restart, { description = "Restart SomeWM", group = "somewm" }),
	awful.key({ modkey, shift }, "q", awesome.quit, { description = "Quit SomeWM", group = "somewm" }),

	-- Launchers
	awful.key({ modkey }, "Return", apps.terminal, { description = "Launch Terminal", group = "launcher" }),
	awful.key({ modkey }, "b", apps.browser, { description = "Launch Browser", group = "launcher" }),
	awful.key({ modkey }, "f", apps.file_browser, { description = "Launch File Browser", group = "launcher" }),

	-- Media Keys
	awful.key({}, "XF86AudioNext", function()
		awful.spawn("playerctl next")
	end, { description = "Next media track", group = "media" }),
	awful.key({}, "XF86AudioPrev", function()
		awful.spawn("playerctl previous")
	end, { description = "Previous media track", group = "media" }),
	awful.key({}, "XF86AudioPlay", function()
		awful.spawn("playerctl play-pause")
	end, { description = "Play/Pause media", group = "media" }),
	awful.key({}, "XF86AudioStop", function()
		awful.spawn("playerctl stop")
	end, { description = "Stop media", group = "media" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn("amixer set Master toggle")
	end, { description = "Mute volume", group = "media" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn("amixer set Master 5%+")
	end, { description = "Increase Volume", group = "media" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn("amixer set Master 5%-")
	end, { description = "Lower Volume", group = "media" }),
})
