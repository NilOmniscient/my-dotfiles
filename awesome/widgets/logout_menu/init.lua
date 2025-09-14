local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local beautiful = require("beautiful")

local ICONS = "/usr/share/icons/breeze-dark/actions/24/"

local logout_menu_widget = wibox.widget({
  {
    {
      text = " ⏻ ",
      font = beautiful.font,
      widget = wibox.widget.textbox,
    },
    margins = 4,
    layout = wibox.container.margin,
  },
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  widget = wibox.container.background,
})

local popup = awful.popup({
  ontop = true,
  visible = false,
  shape = function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, 10)
  end,
  border_width = 1,
  border_color = beautiful.bg_focus,
  maximum_width = 400,
  offset = { y = 5 },
  widget = {},
})

local function worker(user_args)
  local rows = { layout = wibox.layout.fixed.vertical }
  local args = user_args or {}
  local font = args.font or beautiful.font

  local onlogout = args.onlogout or function()
    awesome.quit()
  end
  local onlock = args.onlock or function()
    awful.spawn.with_shell(
      "xidlehook-client --socket /run/user/1000/xidlehook.socket control --action Trigger --timer 0")
  end
  local onreboot = args.onreboot or function()
    awful.spawn.with_shell("loginctl reboot")
  end
  local onsuspend = args.onsuspend or function()
    awful.spawn.with_shell("loginctl suspend")
  end
  local onpoweroff = args.onpoweroff or function()
    awful.spawn.with_shell("loginctl poweroff")
  end

  local menu_items = {
    { name = "󰍃 Log Out", command = onlogout },
    { name = " Lock", command = onlock },
    { name = " Reboot", command = onreboot },
    { name = "󰒲 Suspend", command = onsuspend },
    { name = "⏻ Shutdown", command = onpoweroff },
  }

  for _, item in ipairs(menu_items) do
    local row = wibox.widget({
      {
        {
          text = item.name,
          font = font,
          widget = wibox.widget.textbox,
        },
        margins = 8,
        layout = wibox.container.margin,
      },
      fg = beautiful.fg_normal,
      bg = beautiful.bg_normal,
      widget = wibox.container.background,
    })
    row:connect_signal("mouse::enter", function(c)
      c:set_bg(beautiful.bg_focus)
      c:set_fg(beautiful.fg_focus)
    end)
    row:connect_signal("mouse::leave", function(c)
      c:set_bg(beautiful.bg_normal)
      c:set_fg(beautiful.fg_normal)
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
      popup.visible = not popup.visible
      logout_menu_widget:set_bg("#00000000")
      item.command()
    end)))

    table.insert(rows, row)
  end
  popup:setup(rows)

  logout_menu_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    if popup.visible then
      popup.visible = not popup.visible
      logout_menu_widget:set_bg("#00000000")
    else
      popup:move_next_to(mouse.current_widget_geometry)
      logout_menu_widget:set_bg(beautiful.bg_focus)
    end
  end)))

  return logout_menu_widget
end

return worker
