local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local power_menu_popup = awful.popup {
  ontop = true,
  visible = false,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  border_width = 1,
  border_color = theme.bg_focus,
  offset = { y = 5 },
  widget = {},
}

-- Set up the menu options.
local rows = { layout = wibox.layout.fixed.vertical }
local onlogout = function()
  awesome.quit()
end
local onlock = function()
  awful.spawn_width_shell("xautolock -locknow")
end
local onreboot = function()
  awful.spawn_width_shell("loginctl reboot")
end
local onsuspend = function()
  awful.spawn_with_shell("loginctl suspend")
end
local onpoweroff = function()
  awful.spawn_with_shell("loginctl poweroff")
end
local menu_items = {
  { name = "Log Out", text = " 󰍃 ", command = onlogout },
  { name = "Lock", text = "  ", command = onlock },
  { name = "Reboot", text = "  ", command = onreboot },
  { name = "Suspend", text = " 󰒲 ", command = onsuspend },
  { name = "Shutdown", text = " ⏻ ", command = onpoweroff },
}

for _, item in ipairs(menu_items) do
  local row = wibox.widget {
    {
      {
        {
          text = item.text,
          font = theme.font,
          widget = wibox.widget.textbox,
        },
        {
          text = item.name,
          font = theme.font,
          widget = wibox.widget.textbox,
        },
        spacing = 12,
        layout = wibox.layout.fixed.horizontal,
      },
      margins = 8,
      layout = wibox.container.margin,
    },
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    widget = wibox.container.background,
  }
  row:connect_signal("mouse::enter", function(c)
    c:set_bg(theme.bg_focus)
    c:set_fg(theme.fg_focus)
  end)
  row:connect_signal("mouse::leave", function(c)
    c:set_bg(theme.bg_normal)
    c:set_fg(theme.fg_normal)
  end)

  local old_cursor, old_wibox
  row:connect_signal("mouse::enter", function()
    local wb = mouse.current_wibox
    old_cursor, old_wibox = wb.cursor, wb
    wb.cursor = "handi"
  end)
  row:connect_signal("mouse::leave", function()
    if old_wibox then
      old_wibox.cursor = old_cursor
      old_wibox = nil
    end
  end)

  row:buttons(awful.util.table.join(awful.button({}, 1, function()
    power_menu_popup.visible = not power_menu_popup.visible
    item.command()
  end)))
end
power_menu_popup:setup(rows)

local function toggle_power_menu()
  power_menu_popup.visible = not power_menu_popup.visible
end
