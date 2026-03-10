-- Screen configurations, e.g. taglists, wibars, etc.
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Widgets
local taglist_builder = require("widgets.default.taglist_buttons")
local tasklist_builder = require("widgets.default.tasklist_buttons")
local layout_box = require("widgets.default.layout_box")

local myawesomemenu = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "manual", terminal .. " -e man awesome" },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

local mymainmenu = awful.menu({
	items = {
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

local mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

-- Keyboard map indicator and switcher
local mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
local mytextclock = wibox.widget.textclock()

local setup_screens = function(modkey, client)
	awful.screen.connect_for_each_screen(function(s)
		awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
		-- Create a promptbox for each screen
		s.mypromptbox = awful.widget.prompt()
		-- Create an imagebox widget which will contain an icon indicating which layout we're using.
		-- We need one layoutbox per screen.
		s.mylayoutbox = awful.widget.layoutbox(s)
		s.mylayoutbox:buttons(layout_box)
		-- Create a taglist widget
		s.mytaglist = taglist_builder(modkey, client, s)
		-- Create a tasklist widget
		s.mytasklist = tasklist_builder(client, s)
		-- Create the wibox
		s.mywibox = awful.wibar({ position = "top", screen = s })
		-- Add widgets to the wibox
		s.mywibox:setup({
			layout = wibox.layout.align.horizontal,
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				mylauncher,
				s.mytaglist,
				s.mypromptbox,
			},
			s.mytasklist, -- Middle widget
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				mykeyboardlayout,
				wibox.widget.systray(),
				mytextclock,
				s.mylayoutbox,
			},
		})
	end)
end

return setup_screens
