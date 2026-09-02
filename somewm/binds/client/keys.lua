local awful = require("awful")
local mod = require("binds.mod")
local modkey = mod.modkey
local ctrl = mod.ctrl
local shift = mod.shift
local alt = mod.alt

local client = require("client")

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		-- Client State
		awful.key({ modkey }, "a", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "fullscreen", group = "client" }),
		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),
		awful.key({ modkey }, "space", function(c)
			c.floating = not c.floating
		end, { description = "toggle floating", group = "client" }),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),
		awful.key({ modkey, ctrl }, "m", function(c)
			c.maximized_vertical = not c.maximized_vertical
			c:raise()
		end, { description = "(un)maximize vertically", group = "client" }),
		awful.key({ modkey, shift }, "m", function(c)
			c.maximized_horizontal = not c.maximized_horizontal
			c:raise()
		end, { description = "(un)maximize horizontally", group = "client" }),

		-- Client position management
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "toggle keep on top", group = "client" }),
		awful.key({ modkey }, "right", function(c)
			local f = awful.placement.scale + awful.placement.right + awful.placement.maximize_vertically
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client right", group = "floating client" }),
		awful.key({ modkey }, "left", function(c)
			local f = awful.placement.scale + awful.placement.left + awful.placement.maximize_vertically
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client left", group = "floating client" }),
		awful.key({ modkey }, "up", function(c)
			local f = awful.placement.scale + awful.placement.top + awful.placement.maximize_horizontally
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client top", group = "floating client" }),
		awful.key({ modkey }, "down", function(c)
			local f = awful.placement.scale + awful.placement.bottom + awful.placement.maximize_horizontally
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client bottom", group = "floating client" }),
	})
end)
