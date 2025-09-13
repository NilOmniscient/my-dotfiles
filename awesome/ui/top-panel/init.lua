local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")

configuration = require("configuration.config")
require("widgets.top-panel")

local TopPanel = function(s)
  -- Wiboxes are much more flexible than wibars simply for the fact that there are no defaults, however if you'd rather have the ease of a wibar you can replace this with the original wibar code
  local panel = awful.wibar({
    ontop = true,
    screen = s,
    height = configuration.toppanel_height,
    width = s.geometry.width,
    x = s.geometry.x,
    y = s.geometry.y,
    stretch = false,
    bg = beautiful.background,
    fg = beautiful.fg_normal,
    strut = {
      top = configuration.toppanel_height,
    },
  })

  local logout_menu = require("widgets.logout_menu")
  local media_player = require("widgets.media_player")
  local powermon = require("widgets.powermon")
  local volume_widget = require("awesome-wm-widgets.volume-widget.volume")

  local left_widgets = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    s.mylayoutbox,
    s.mytaglist,
  })
  local middle_widgets = wibox.widget({
    layout = wibox.layout.fixed.horizontal,
    media_player,
  })
  local right_widgets = {}
  if s.index == 1 then
    right_widgets = wibox.widget({
      layout = wibox.layout.fixed.horizontal,
      spacing = 4,
      wibox.widget.systray(),
      volume_widget {
        widget_type = "icon"
      },
      powermon,
      mytextclock,
      logout_menu(),
    })
  else
    right_widgets = wibox.widget({
      layout = wibox.layout.fixed.horizontal,
      spacing = 4,
      mytextclock,
    })
  end

  local wrap_widget = function(w)
    local wrapped = wibox.widget({
      layout = wibox.layout.fixed.horizontal,
      {
        {
          w,
          top = 2,
          bottom = 2,
          left = 10,
          right = 10,
          color = beautiful.wrapped_bg,
          widget = wibox.container.margin,
        },
        bg = beautiful.wrapped_bg,
        widget = wibox.container.background,
        shape = gears.shape.rounded_rect,
        shape_border_width = 2,
        shape_border_color = beautiful.wrapped_fg,
      },
    })
    return wrapped
  end

  panel:setup({
    layout = wibox.layout.align.horizontal,
    expand = "none",
    wrap_widget(left_widgets),
    wrap_widget(middle_widgets),
    wrap_widget(right_widgets),
  })

  return panel
end

return TopPanel
