local awful = require("awful")
local screen = require("screen")

local mod = require("binds.mod")
local modkey = mod.modkey

--- Client keybindings.
client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		-- Client state management.
		awful.key({ modkey }, "a", function(c)
			c.fullscreen = not c.fullscreen
			c:raise()
		end, { description = "toggle fullscreen", group = "client" }),
		awful.key({ modkey }, "q", function(c)
			c:kill()
		end, { description = "close", group = "client" }),
		awful.key(
			{ modkey, mod.ctrl },
			"space",
			awful.client.floating.toggle,
			{ description = "toggle floating", group = "client" }
		),
		awful.key({ modkey }, "m", function(c)
			c.maximized = not c.maximized
			c:raise()
		end, { description = "(un)maximize", group = "client" }),

		-- Client position in tiling management.
		awful.key({ modkey, mod.ctrl }, "Return", function(c)
			c:swap(awful.client.getmaster())
		end, { description = "move to master", group = "client" }),
		awful.key({ modkey }, "o", function(c)
			c:move_to_screen()
		end, { description = "move to screen", group = "client" }),
		awful.key({ modkey }, "t", function(c)
			c.ontop = not c.ontop
		end, { description = "toggle keep on top", group = "client" }),

		-- Client position in Floating mode.
		awful.key({ modkey }, "Right", function(c)
			local f = awful.placement.scale + awful.placement.right + awful.placement.maximize_vertically
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client right", group = "client" }),
		awful.key({ modkey }, "Left", function(c)
			local f = awful.placement.scale + awful.placement.left + awful.placement.maximize_vertically
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client left", group = "client" }),
		awful.key({ modkey }, "Up", function(c)
			local f = awful.placement.scale + awful.placement.top + awful.placement.maximize_horizontally
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client top", group = "client" }),
		awful.key({ modkey }, "Down", function(c)
			local f = awful.placement.scale + awful.placement.bottom + awful.placement.maximize_horizontally
			f(c, { honor_workarea = true, to_percent = 0.5 })
		end, { description = "snap client bottom", group = "client" }),

		-- Client screen in Floating mode.
		awful.key({ modkey, mod.shift }, "Right", function(c)
			local target = c.screen:get_next_in_direction("right")
			if target then
				c:move_to_screen(target)
			else
				c:move_to_screen(0)
			end
		end, { description = "move client to next right screen", group = "client" }),
		awful.key({ modkey, mod.shift }, "Left", function(c)
			local target = c.screen:get_next_in_direction("left")
			if target then
				c:move_to_screen(target)
			else
				c:move_to_screen(screen.count() - 1)
			end
		end, { description = "move client to next left screen", group = "client" }),
	})
end)
