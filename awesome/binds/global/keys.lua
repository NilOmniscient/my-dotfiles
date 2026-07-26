local awful = require("awful")

local mod = require("binds.mod")
local modkey = mod.modkey

local apps = require("config.apps")

local power_menu = require("widgets.power_menu")
local windowswitcher = require("widgets.windowswitcher")
local launcher = require("widgets.launcher")
local notifications = require("module.notifications")

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

-- Slowly convert declarative style keys to table.

local global_keys = {
	-- Awesome keybinds.
	{ { modkey }, "s", require("awful.hotkeys_popup").show_help, "Show Help", "awesome" },
	{
		{ modkey },
		"w",
		function()
			require("ui.menu").main:show()
		end,
		"Show Awesome Menu",
		"awesome",
	},
	{ { modkey, mod.ctrl }, "r", awesome.restart, "Restart Awesome", "awesome" },
	{ { modkey, mod.shift }, "q", awesome.quit, "Quit Awesome", "awesome" },
	-- Client keybinds.
	{ { modkey }, "Tab", windowswitcher.show, "Window Switcher", "client" },

	-- Launcher keybinds.
	{ { modkey }, "Return", apps.terminal, "Launch Terminal", "launcher" },
	{ { modkey }, "b", apps.browser, "Launch Browser", "launcher" },
	{ { modkey }, "f", apps.file_browser, "Launch File Browser", "launcher" },
	{ { modkey }, "r", launcher.show, "Application Launcher", "launcher" },
	{ { modkey }, "l", apps.locker, "Lock Screen", "awesome" },

	-- Dashboard Controls
	{ { modkey, "Shift" }, "n", notifications.toggle_notification_center, "Toggle Notifications", "awesome" },
}
awful.keyboard.append_global_keybindings(table_to_keybinding(global_keys))

--- Global key bindings
awful.keyboard.append_global_keybindings({
	-- General Awesome keys.
	awful.key({ modkey }, "x", function()
		awful.prompt.run({
			prompt = "Run Lua code: ",
			textbox = awful.screen.focused().mypromptbox.widget,
			exe_callback = awful.util.eval,
			history_path = awful.util.get_cache_dir() .. "/history_eval",
		})
	end, { description = "lua execute prompt", group = "awesome" }),

	-- Tags related keybindings.
	awful.key({ modkey }, "Left", awful.tag.viewprev, { description = "view previous", group = "tag" }),
	awful.key({ modkey }, "Right", awful.tag.viewnext, { description = "view next", group = "tag" }),
	awful.key({ modkey }, "Escape", awful.tag.history.restore, { description = "go back", group = "tag" }),

	-- Focus related keybindings.
	awful.key({ modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focus next by index", group = "client" }),
	awful.key({ modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focus previous by index", group = "client" }),

	awful.key({ modkey, mod.ctrl }, "j", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	awful.key({ modkey, mod.ctrl }, "k", function()
		awful.screen.focus_relative(-1)
	end, { description = "focus the previous screen", group = "screen" }),
	awful.key({ modkey, mod.ctrl }, "n", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:activate({ raise = true, context = "key.unminimize" })
		end
	end, { description = "restore minimized", group = "client" }),

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

	-- Custom keys

	awful.key({ modkey }, "p", function()
		local active_screen = awful.screen.focused()
		awful.placement.centered(power_menu, {
			parent = active_screen,
		})
		power_menu:show()
	end, { description = "power menu", group = "awesome" }),
})
