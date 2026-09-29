local awful = require("awful")

local mod = require("binds.mod")
local modkey = mod.modkey

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

local client_helpers = {
	fullscreen = function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end,
	close = function(c)
		c:kill()
	end,
	maximize = function(c)
		c.maximized = not c.maximized
		c:raise()
	end,
	snap_right = function(c)
		local f = awful.placement.scale + awful.placement.right + awful.placement.maximize_vertically
		f(c, { honor_workarea = true, to_percent = 0.5 })
	end,
	snap_left = function(c)
		local f = awful.placement.scale + awful.placement.left + awful.placement.maximize_vertically
		f(c, { honor_workarea = true, to_percent = 0.5 })
	end,
	snap_top = function(c)
		local f = awful.placement.scale + awful.placement.top + awful.placement.maximize_horizontally
		f(c, { honor_workarea = true, to_percent = 0.5 })
	end,
	snap_bottom = function(c)
		local f = awful.placement.scale + awful.placement.bottom + awful.placement.maximize_horizontally
		f(c, { honor_workarea = true, to_percent = 0.5 })
	end,
	move_left = function(c)
		local target = c.screen:get_next_in_direction("right")
		if target then
			c:move_to_screen(target)
		else
			c:move_to_screen(0)
		end
	end,
	move_right = function(c)
		local target = c.screen:get_next_in_direction("left")
		if target then
			c:move_to_screen(target)
		else
			c:move_to_screen(awful.screen.count() - 1)
		end
	end,
}

local client_keys = {
	-- Basic client state management
	{ { modkey }, "a", client_helpers.fullscreen, "toggle_fullscreen", "client" },
	{ { modkey }, "q", client_helpers.close, "close", "client" },
	{ { modkey }, "m", client_helpers.maximize, "(un)maximize", "client" },

	-- Client position management
	{ { modkey }, "Right", client_helpers.snap_right, "snap client right", "client" },
	{ { modkey }, "Left", client_helpers.snap_left, "snap client left", "client" },
	{ { modkey }, "Up", client_helpers.snap_top, "snap client top", "client" },
	{ { modkey }, "Down", client_helpers.snap_bottom, "snap client bottom", "client" },

	-- Client screen management
	{ { modkey, mod.shift }, "Right", client_helpers.move_right, "move client to next right screen", "client" },
	{ { modkey, mod.shift }, "Left", client_helpers.move_left, "move client to next left screen", "client" },
}

--- Convert and connect the keybindings.
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings(table_to_keybinding(client_keys))
end)
