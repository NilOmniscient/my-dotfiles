local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local onlogout = function()
  awesome.quit()
end
local onlock = function()
  awful.spawn.with_shell("xautolock -locknow")
end
local onreboot = function()
  awful.spawn.with_shell("loginctl reboot")
end
local onsuspend = function()
  awful.spawn.with_shell("loginctl suspend")
end
local onpoweroff = function()
  awful.spawn.with_shell("loginctl poweroff")
end

local menu_items = {
  { name = "Log Out", text = "󰍃", command = onlogout },
  { name = "Lock", text = "", command = onlock },
  { name = "Reboot", text = "", command = onreboot },
  { name = "Suspend", text = "󰒲", command = onsuspend },
  { name = "Shutdown", text = "⏻", command = onpoweroff },
}

local function build_popup()
  local power_menu_popup = awful.popup {
    widget = {},
    placement = awful.placement.centered,
    shape = function(cr, width, height)
      gears.shape.rounded_rect(cr, width, height, 10)
    end,
    border_width = 1,
    border_color = theme.bg_focus,
    ontop = true,
    visible = false,
  }

  local rows = {
    layout = wibox.layout.fixed.vertical,
  }
  for _, item in ipairs(menu_items) do
    local row = wibox.widget {
      widget = wibox.container.background,
      {
        layout = wibox.container.margin,
        {
          layout = wibox.layout.fixed.horizontal,
          {
            widget = wibox.widget.textbox,
            font = theme.font,
            text = item.text,
          },
          {
            widget = wibox.widget.textbox,
            font = theme.font,
            text = item.name,
          },
          spacing = 12,
          forced_width = 300,
          forced_height = 40,
        },
        margins = 8,
      },
      fg = theme.fg_normal,
      bg = theme.bg_normal,
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
      power_menu_popup.visible = false
      item.command()
    end)))

    table.insert(rows, row)
  end
  power_menu_popup:setup(rows)
  return power_menu_popup
end

return build_popup
