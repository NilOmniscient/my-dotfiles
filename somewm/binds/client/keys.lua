local awful = require("awful")
local client = require("client")
local mod = require("binds.mod")
local modkey = mod.modkey
local shift = mod.shift

local helper = require("binds.helpers").table_to_bindings

local client_helpers = {
	toggle_fullscreen = function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end,
	close_client = function(c)
		c:kill()
	end,
	toggle_floating = function(c)
		c.floating = not c.floating
	end,
	toggle_maximize = function(c)
		c.maximized = not c.maximized
	end,
	toggle_ontop = function(c)
		c.ontop = not c.ontop
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
	move_to_left = function(c)
		local s = c.screen:get_next_in_direction("left")
		c:move_to_screen(s)
	end,
	move_to_right = function(c)
		local s = c.screen:get_next_in_direction("right")
		c:move_to_screen(s)
	end,
}

local client_bindings = {
	-- Client State
	{ { modkey }, "a", client_helpers.toggle_fullscreen, "Toggle Fullscreen", "client" },
	{ { modkey }, "q", client_helpers.close_client, "Close Client", "client" },
	{ { modkey }, "space", client_helpers.toggle_floating, "Toggle Floating", "client" },
	{ { modkey }, "m", client_helpers.toggle_maximize, "(un)maximize", "client" },
	{ { modkey }, "t", client_helpers.toggle_ontop, "Toggle keep on top", "client" },

	-- Client Position
	{ { modkey }, "Right", client_helpers.snap_right, "Snap to right edge", "floating client" },
	{ { modkey }, "Left", client_helpers.snap_left, "Snap to left edge", "floating client" },
	{ { modkey }, "Up", client_helpers.snap_top, "Snap to top edge", "floating client" },
	{ { modkey }, "Down", client_helpers.snap_bottom, "Snap to bottom edge", "floating client" },

	-- Client screen management
	{ { modkey, shift }, "Left", client_helpers.move_to_left, "Move left one screen", "client" },
	{ { modkey, shift }, "Right", client_helpers.move_to_right, "Move Right one screen", "client" },
}

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings(helper(client_bindings))
end)
