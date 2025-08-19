local theme = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local playerctl_module = require("modules.playerctl")
local playerctl = playerctl_module()

local log_message = function(s)
  local filepath = "/home/bwhittington/adv_media.log"
  local file = io.open(filepath, "a")
  if file then
    file:write(s)
    file:close()
  end
end

local active_source = ""
local source_selector = awful.popup {
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  shape = gears.shape.rounded_rect,
  border_color = theme.bg_focus,
  border_width = 1,
  maximum_width = 200,
  offset = { y = 5 },
  ontop = true,
  visible = false,
  widget = {},
}
local source_text = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Source",
  ellipsize = "end",
  forced_width = 200,
  buttons = awful.button({}, 1, nil, function()
    if source_selector.visible == false then
      source_selector:move_next_to(mouse.current_widget_geometry)
    end
    source_selector.visible = not source_selector.visible
  end)
}

-- Connect the playerctl signal for source rebuild. 
local function build_row(w)
  local row = wibox.widget {
    widget = wibox.container.background,
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    {
      layout = wibox.container.margin,
      margins = 8,
      w
    }
  }
  return row
end
local function build_textbox(text)
  return wibox.widget {
    widget = wibox.widget.textbox,
    font = theme.font,
    text = text,
  }
end
playerctl:connect_signal("players", function(_, player_names)
  local rows = { layout = wibox.layout.fixed.vertical }
  for name in player_names:gmatch("[^\r\n]+") do
    local row = build_row(build_textbox(name))
    row.buttons = awful.button({}, 1, nil, function()
      active_source = name
      playerctl:set_player(name)
      source_selector.visible = false
    end)
    table.insert(rows, row)
  end
  source_selector:setup(rows)
end)

local final_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  source_text,
}
return final_widget
