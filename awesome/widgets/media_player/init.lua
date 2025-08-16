local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

-- Build local variables
local watch_fields = { -- Fields playerctl will check for. 
  [1] = "status",
  [2] = "xesam:artist",
  [3] = "xesam:title",
}
local player_source = ""

-- Start building widgets that will be needed. 
-- Start with the source selector
local source_selector = awful.popup({
  bg = beautiful.bg_normal,
  fg = beautiful.fg_normal,
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect,
  border_width = 1,
  border_color = beautiful.bg_focus,
  maximum_width = 200,
  offset = { y = 5 },
  widget = {},
})
local source_text = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Source",
  ellipsize = "end",
  forced_width = 100,
  buttons = awful.button({}, 1, nil, function()
    if source_selector.visible then
      source_selector.visible = false
    else
      rebuild_selector()
    end
  end)
}
local source_container = wibox.widget({
  layout = wibox.container.margin,
  left = 8, right = 8,
  maximum_width = 100,
  source_text,
})

-- Now the container holding the "Now Playing" text.
local player_text = wibox.widget({
  widget = wibox.widget.textbox,
  text = "Nothing Playing Right Now",
  ellipsize = true,
  forced_width = 300,
  align = "center",
})
local player_container = wibox.widget({
  layout = wibox.container.margin,
  left = 8, right = 8,
  player_text,
})

-- Finally the media controls. 
local prev_button = wibox.widget{
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.widget.textbox,
    text = " 󰒮 ",
    buttons = awful.button({}, 1, nil, function()
      local cmd = "playerctl "
      if player_source ~= "" then
        cmd = cmd .. "-p " .. player_source .. " "
      end
      cmd = cmd .. "previous"
      awful.spawn(cmd)
    end)
  }
}
local pause_button = wibox.widget{
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.widget.textbox,
    text = " 󰐎 ",
    buttons = awful.button({}, 1, nil, function()
      local cmd = "playerctl "
      if player_source ~= "" then
        cmd = cmd .. "-p " .. player_source .. " "
      end
      cmd = cmd .. "play-pause"
      awful.spawn(cmd)
    end)
  }
}
local next_button = wibox.widget{
  layout = wibox.layout.fixed.horizontal,
  {
    widget = wibox.widget.textbox,
    text = " 󰒭 ",
    buttons = awful.button({}, 1, nil, function()
      local cmd = "playerctl "
      if player_source ~= "" then
        cmd = cmd .. "-p " .. player_source .. " "
      end
      cmd = cmd .. "next"
      awful.spawn(cmd)
    end)
  }
}
local controls = wibox.widget({
  layout = wibox.layout.align.horizontal,
  spacing = 10,
  prev_button, pause_button, next_button
})

-- Functions used by widgets
function rebuild_selector()
  awful.spawn.easy_async("playerctl -l", function(stdout, _, _, _)
    local rows = {
      layout = wibox.layout.fixed.vertical
    }
    -- Get the list of sources. 
    if stdout ~= "" then
      for name in stdout:gmatch("[^\r\n]+") do
        if name ~= "" and name ~= nil then
          local split = gears.string.split(name, ".")
          -- Set up a row, and append it to rows.
          local row = wibox.widget({
            {
              layout = wibox.container.margin,
              margins = 8,
              {
                text = split[1],
                font = beautiful.font,
                widget = wibox.widget.textbox,
              }
            },
            fg = beautiful.fg_normal,
            bg = beautiful.bg_normal,
            widget = wibox.container.background,
buttons = awful.button({}, 1, nil, function()
              update_source(name)
              source_selector.visible = false
            end)
          })
          row:connect_signal("mouse::enter", function(c)
            c:set_bg(beautiful.bg_focus)
            c:set_fg(beautiful.fg_focus)
          end)
          row:connect_signal("mouse::leave", function(c)
            c:set_bg(beautiful.bg_normal)
            c:set_fg(beautiful.fg_normal)
          end)
          table.insert(rows, row)
        end
      end
      source_selector:setup(rows)
      source_selector:move_next_to(mouse.current_widget_geometry)
      source_selector.visible = true
    end
  end)
end

function update_source(src)
  player_source = src
  local split = gears.string.split(src, ".")
  source_text:set_text(split[1])
  if src ~= "" then
    watch_cmd = string.format("playerctl -f '{{%s}}' -p '" .. player_source .. "' metadata", table.concat(watch_fields, "}};{{"))
  else
    watch_cmd = string.format("playerctl -f '{{%s}}' metadata", table.concat(watch_fields, "}};{{"))
  end
end

-- Timers.
-- First, on launch, select the first available source (if any)
gears.timer{
  timeout = 0.1,
  autostart = true,
  call_now = true,
  single_shot = true,
  callback = function()
    if player_source == "" then
awful.spawn.easy_async("playerctl -l", function(stdout, _, _, _)
        if stdout ~= "" then
          for name in stdout:gmatch("[^\r\n]+") do
            if name ~= "" and name ~= nil then
              update_source(name)
              break
            end
          end
        end
      end)
    end
  end
}

-- This timer runs periodically, and updates the "Now Playing" section
gears.timer{
  timeout = 0.3,
  autostart = true,
  call_now = true,
  callback = function()
    awful.spawn.easy_async(watch_cmd, function(stdout, _, _, _)
local words = gears.string.split(stdout, ";")
      local metadata = {}
      local status, artist, title = trim(words[1]), trim(words[2]), trim(words[3])
      if status ~= "" then 
        if status == "Playing" then
          status = "||"
        else
          status = "||"
        end
        table.insert(metadata, status)
      end
      if title ~= "" then table.insert(metadata, "󰎇 " .. title) end
      if artist ~= "" then table.insert(metadata, "󰠃 " .. artist) end
      local contents = table.concat(metadata, " | ")
      local text = ""
      if contents ~= "" then
        text = " " .. table.concat(metadata, " ") .. " "
      else
        text = " Nothing playing right now "
      end
      player_text:set_text(text)
    end)
  end
}

-- Utility functions
function trim(s)
  if s == nil then
    return ""
  end
  return s:match("^%s*(.-)%s*$")
end

-- Ok, now return the full widget. 
return wibox.widget({
  source_container,
  player_container,
  controls,
  layout = wibox.layout.align.horizontal,
})
