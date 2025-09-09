local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local active_row = {}

local function build_row(row_widget, row_callback)
  local row = wibox.widget {
    widget = wibox.container.background,
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    {
      layout = wibox.container.margin,
      margins = 8,
      row_widget,
    },
    callback = row_callback,
  }
  row:connect_signal("mouse::enter", function(c)
    active_row = row
    c:set_bg(theme.bg_focus)
    c:set_fg(theme.fg_focus)
  end)
  row:connect_signal("mouse::leave", function(c)
    active_row = row
    c:set_bg(theme.bg_normal)
    c:set_fg(theme.fg_normal)
  end)

  row:buttons(awful.util.table.join(awful.button({}, 1, function()
    row_callback()
  end)))
  return row
end

local function build_text_row(row_text, row_callback)
  local textbox = wibox.widget {
    widget = wibox.widget.textbox,
    text = row_text,
    font = theme.font,
  }
  return build_row(textbox, row_callback)
end

local function build_menu(items, close_key)
  -- Items expects a table in the following format
  -- { {widget, callback}, {text, callback}, {widget, callback} } etc.
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

  popup.row_count = 0
  popup.rows = { layout = wibox.layout.fixed.vertical }
  popup.indices = {}

  for i, item in ipairs(items) do
    -- Make a row, keep track of it, it's index, and the row row_count.
    local row = {}
    if type(item[1]) == "string" then
      row = build_text_row(item[1], item[2])
    else
      row = build_row(item[1], item[2])
    end
    local count = popup.row_count;
    popup.row_count = popup.row_count + 1
    table.insert(popup.rows, row)
    popup.indices[row] = popup.row_count
  end

  popup:setup(popup.rows)

  local function command_wrapper(callback)
    popup.visible = false
    callback()
  end

  local function switch_focus(old_row, new_row)
    if old_row then
      old_row:set_fg(theme.fg_normal)
      old_row:set_bg(theme.bg_normal)
    end
    if new_row then
      new_row:set_fg(theme.fg_focus)
      new_row:set_bg(theme.bg_focus)
    end
  end

  close_key = close_key or "Escape"
  local kg = awful.keygrabber {
    stop_callback = function()
      switch_focus(active_row, nil)
      popup.visible = false
    end,
    stop_event = "release",
    stop_key = { close_key },
    keybindings = {
      { {}, "Up", function()
        if popup.row_count > 0 then
          local index = popup.indices[active_row]
          if index == 1 then
            index = popup.row_count
          else
            index = index - 1
          end
          local old_active = active_row
          active_row = popup.rows[index]
          switch_focus(old_active, active_row)
        end
      end },
      { {}, "Down", function()
        if popup.row_count > 0 then
          local index = popup.indices[active_row]
          if index == popup.row_count then
            index = 1
          else
            index = index + 1
          end
          local old_active = active_row
          active_row = popup.rows[index]
          switch_focus(old_active, active_row)
        end
      end },
    }
  }
  kg:add_keybinding(
    {}, "Return", function()
      -- Perform the row callback, and stop the keygrabber.
      active_row:callback()
      kg:stop()
    end
  )

  function popup.toggle()
    if popup.visible then
      kg:stop()
    else
      active_row = popup.rows[1]
      switch_focus(nil, active_row)
      popup.visible = true
      kg:start()
    end
  end

  return popup
end

return build_menu
