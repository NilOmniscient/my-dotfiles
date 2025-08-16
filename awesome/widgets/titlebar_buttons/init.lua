local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

function floatingbutton(c)
  local float = "  "
  local tile = " 󰝘 "
  local btn = wibox.widget({
    font = theme.font,
    widget = wibox.widget.textbox,
    text = tile
  })
  local callback = function()
    c.floating = not c.floating
    if c.floating then btn:set_text(float)
    else btn:set_text(tile) end
  end
  if c.floating then btn:set_text(float) end
  btn.buttons = awful.button({}, 1, nil, function() callback() end)
  return btn
end
function maximizedbutton(c)
  local minimize = "  "
  local maximize = "  "
  local btn = wibox.widget({
    font = theme.font,
    widget = wibox.widget.textbox,
    text = maximize,
  })
  local callback = function()
    c.maximized = not c.maximized
    if c.maximized then btn:set_text(minimize)
    else btn:set_text(maximize) end
  end
  if c.maximized then btn:set_text(minimize) end
  btn.buttons = awful.button({}, 1, nil, function() callback() end)
  return btn
end
function minimizedbutton(c)
  return generate_button("  ", function()
    c.minimized = true
  end)
end
function stickybutton(c)
  local pin = " 󰐃 "
  local unpin = " 󰤰 "
  local btn = wibox.widget({
    font = theme.font,
    widget = wibox.widget.textbox,
  })
  local callback = function()
    c.sticky = not c.sticky
    if c.sticky == true then
      btn:set_text(unpin)
    else
      btn:set_text(pin)
    end
  end
  local text = pin
  if c.sticky == true then text = unpin end
  btn:set_text(text)
  btn.buttons = awful.button({}, 1, nil, function()
    callback()
  end)
  return btn
end
function ontopbutton(c)
  local btn = wibox.widget({
    font = theme.font,
    widget = wibox.widget.textbox,
  })
  local lowered = "  "
  local raised = "  "
  local callback = function()
    c.ontop = not c.ontop
    if c.ontop == true then 
      btn:set_text(raised)
    else
      btn:set_text(lowered)
    end
  end
  local text = lowered;
  if c.ontop == true then text = raised end
  btn:set_text(text)
  btn.buttons = awful.button({}, 1, nil, function()
    callback()
  end)
  return btn
end
function closebutton(c)
  local callback = function()
    c:kill()
  end
  return generate_button("  ", callback)
end

function generate_button(text, action)
  local btn = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    {
      font = theme.font,
      widget = wibox.widget.textbox,
      text = text,
      buttons = awful.button({}, 1, nil, function()
        action()
      end)
    }
  })
  return btn
end

local custom_buttons = {
  floatingbutton = floatingbutton,
  stickybutton = stickybutton,
  minimizedbutton = minimizedbutton,
  maximizedbutton = maximizedbutton,
  closebutton = closebutton,
  ontopbutton = ontopbutton,
}
return custom_buttons
