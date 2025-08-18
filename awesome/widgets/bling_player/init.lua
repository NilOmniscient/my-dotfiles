local theme = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local bling = require("modules/bling")

local players = {}
local active_player = ""

local playerctl = bling.signal.playerctl.lib()

local default_callback = function() end

-- General function to make markup based text boxes. 
function build_textbox(default, callback)
  callback = callback or default_callback
  return wibox.widget {
    widget = wibox.widget.textbox,
    valign = "center",
    align  = "center",
    font   = theme.font,
    markup = default,
  }
end

local title_widget = build_textbox("󰎇 Nothing Playing")
local artist_widget = build_textbox("󰠃 Nothing Playing")
local album_widget = build_textbox("󰀥 Nothing Playing")
local status_widget = build_textbox("||")

function new_player(player_name)
  local player = {
    title = "",
    artist = "",
    album = "",
    active = false,
  }
  return player
end

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)

  -- Update this particular player. 
  local player = {}
  if players[player_name] == nil then
    player = new_player(player_name)
  else
    player = players[player_name]
  end
  player.title = title
  player.artist = artist
  player.album = album
  players[player_name] = player
  if active_player == "" then
    active_player = player_name
  end
  if active_player == player_name then
    title_widget:set_markup_silently("󰎇 " .. title)
    artist_widget:set_markup_silently("󰠃 " .. artist)
    album_widget:set_markup_silently("󰀥 " .. album)
  end
end)
playerctl:connect_signal("playback_status", function(_, playing, player_name)
  if playing then
    status_widget:set_markup_silently("||")
  else
    status_widget:set_markup_silently("||")
  end
end)

-- Make the details popup.
local details = awful.popup {
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect,
  border_widget = 1,
  border_color = theme.bg_focus,
  offset = { y = 5 },
  widget = {},
}
function create_row(w)
  local row = wibox.widget {
    {
      layout = wibox.container.margin,
      margins = 8,
      w,
    },
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    widget = wibox.container.background,
  }
  return row
end
local detail_rows = {
  layout = wibox.layout.fixed.vertical,
  create_row(artist_widget),
  create_row(album_widget),
}
details:setup(detail_rows)
-- Build the control buttons. 
local prev_button = build_textbox("󰒮", function()
  if active_player ~= "" then
    local player = active_player
    playerctl:previous(player)
  end
end)
local play_button = build_textbox("󰐎", function()
  local player = active_player
  playerctl:play_pause(player)
end)
local next_button = build_textbox("󰒭", function()
  playerctl:next()
end)
local controls_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 10,
  prev_button, play_button, next_button,
}

local condensed_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 8,
  status_widget,title_widget,
  buttons = awful.button({}, 1, nil, function()
    if details.visible then
      details.visible = false
    else
      details:move_next_to(mouse.current_widget_geometry)
      details.visible = true
    end
  end)
}
return wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 8,
  condensed_widget, controls_widget,
}
