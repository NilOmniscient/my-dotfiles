local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

function floatingbutton(c)
end
function maximizedbutton(c)
end
function stickybutton(c)
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
  closebutton = closebutton,
  ontopbutton = ontopbutton,
}
return custom_buttons
