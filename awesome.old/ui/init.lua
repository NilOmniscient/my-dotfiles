local awful = require("awful")
local top_panel = require("ui.top-panel")
local bottom_panel = require("ui.bottom-panel")

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s)
	-- You can get edit/rid of this conditional if you want certain bars on specific screens or all screens etc.
	-- if s.index == 1 then
		s.top_panel = top_panel(s)
    s.bottom_panel = bottom_panel(s)
	-- end
end)

-- Hide bars when app go fullscreen
function updateBarsVisibility()
	for s in screen do
		if s.selected_tag then
			local fullscreen = s.selected_tag.fullscreenMode

			-- Make sure a panel does exist on this specific screen, otherwise return
			if s.top_panel ~= nil then
			  s.top_panel.visible = not fullscreen
      end
      if s.bottom_panel ~= nil then
        s.bottom_panel.visible = not fullscreen
      end
		end
	end
end

_G.tag.connect_signal("property::selected", function(t)
	updateBarsVisibility()
end)

_G.client.connect_signal("property::fullscreen", function(c)
	c.screen.selected_tag.fullscreenMode = c.fullscreen
	updateBarsVisibility()
end)

_G.client.connect_signal("unmanage", function(c)
	if c.fullscreen then
		c.screen.selected_tag.fullscreenMode = false
		updateBarsVisibility()
	end
end)
