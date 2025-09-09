local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local log_message = function(s)
  local filepath = "/home/bwhittington/popuppp.log"
  local file = io.open(filepath, "a")
  if file then
    file:write(s)
    file:close()
  end
end

local function build_row(row_text, row_command)
  local row = wibox.widget {
    widget = wibox.container.background,
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    {
      layout = wibox.container.margin,
      margins = 8,
      {
        widget = wibox.widget.textbox,
        text = row_text,
        font = theme.font,
      }
    }
  }
  row:connect_signal("mouse::enter", function(c)
    c:set_bg(theme.bg_focus)
    c:set_fg(theme.fg_focus)
  end)
  row:connect_signal("mouse::leave", function(c)
    c:set_bg(theme.bg_normal)
    c:set_fg(theme.fg_normal)
  end)

  row:buttons(awful.util.table.join(awful.button({}, 1, function()
    row_command()
  end)))
  return row
end


local function build_popup()
  local popup = awful.popup {
    ontop = true,
    visible = false,
    border_width = 1,
    border_color = theme.bg_focus,
    offset = { y = 5 },
    widget = {},
    forced_width = 300,
    forced_height = 80,
  }

  local function command_wrapper(callback)
    popup.visible = false
    callback()
  end
  -- Need to prebuild all the rows.
  local row_one = build_row("Row One", function()
    log_message("Row One Activated")
  end)
  local row_two = build_row("Row Two", function()
    log_message("Row Two Activated")
  end)
  local row_thr = build_row("Row Thr", function()
    log_message("Row Thr Activated")
  end)
  local rows = {
    layout = wibox.layout.fixed.vertical,
    row_one,
    row_two,
    row_thr,
  }
  popup:setup(rows)

  return popup
end

return build_popup()
