local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

configuration = require("configuration.config")
require("widgets.top-panel")

local TopPanel = function(s)
	-- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code
	local panel = wibox({
		ontop = true,
		screen = s,
		height = configuration.toppanel_height,
		width = s.geometry.width,
		x = s.geometry.x,
		y = s.geometry.y,
		stretch = false,
		bg = beautiful.background,
		fg = beautiful.fg_normal,
		struts = {
			top = configuration.toppanel_height,
		},
	})

	panel:struts({
		top = configuration.toppanel_height,
	})
	--

  local logout_menu = require("widgets.logout_menu")
  local volume_control = require("widgets.volume")
  local media_player = require("widgets.media_player")

	panel:setup({
		layout = wibox.layout.align.horizontal,
    expand = "none",
		{ -- Left widgets
			layout = wibox.layout.fixed.horizontal,
			-- mylauncher,
			s.mylayoutbox,
      s.mytaglist,
			-- s.mypromptbox,
		},
    {
      layout = wibox.layout.fixed.horizontal,
      media_player,
    },
		-- s.mytasklist, -- Middle widget
		{ -- Right widgets
			layout = wibox.layout.fixed.horizontal,
			volume_control{
        widget_type = "arc"
      },
			wibox.widget.systray(),
      mytextclock,
      logout_menu(),
		},
	})

	return panel
end

return TopPanel
