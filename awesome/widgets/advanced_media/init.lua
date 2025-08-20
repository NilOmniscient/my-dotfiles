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
}
local function build_sources(player_names)
  log_message("Got to Callback\n")
  local has_name = false
  local rows = { layout = wibox.layout.fixed.vertical }
  for name in player_names:gmatch("[^\r\n]+") do
    if not has_name then
      log_message("Set source to first available\n")
      has_name = true
      if source_text.text == "Source" then
        active_source = name
        source_text:set_text(name)
      end
    end

    local row = build_row(build_textbox(name))
    row.buttons = awful.button({}, 1, nil, function()
      active_source = name
      source_selector.visible = false
      source_text:set_text(name)
      playerctl:set_player(active_source)
    end)
    row:connect_signal("mouse::enter", function(c)
      c:set_bg(theme.bg_focus)
      c:set_fg(theme.fg_focus)
    end)
    row:connect_signal("mouse::leave", function(c)
      c:set_bg(theme.bg_normal)
      c:set_fg(theme.fg_normal)
    end)
    table.insert(rows, row)
  end
  source_selector:setup(rows)
  if not has_name then
    source_text:set_text("Source")
    active_source = ""
    playerctl:set_player(active_source)
  end
end

source_text.buttons = awful.button({}, 1, nil, function()
  log_message("Button Triggered")
  if not source_selector.visible then
    playerctl:get_players(build_sources)
    source_selector:move_next_to(mouse.current_widget_geometry)
  else
    source_selector.visible = false
  end
end)

-- Control buttons and widget.
local function build_button(text, callback)
  local btn = build_textbox(text)
  btn.buttons = awful.button({}, 1, nil, function()
    callback()
  end)
  return btn
end

local controls = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  build_button(" 󰒮 ", function() playerctl:previous() end),
  build_button(" 󰐎 ", function() playerctl:toggle() end),
  build_button(" 󰒭 ", function() playerctl:next() end),
}

local final_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  source_text,
  controls,
}
return final_widget
