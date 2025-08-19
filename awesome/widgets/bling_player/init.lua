local theme = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local bling = require("modules/bling")

function log(s)
  local file = io.open(os.getenv("HOME") .. "bling_player.log", "a")
  if file then
    file:write(os.date() .. "\t" .. s .. "\n")
    file:close()
  end
end

log("Bling player loaded")

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
local player_widget = build_textbox("No players")

function new_player(player_name)
  local player = {
    title = "",
    artist = "",
    album = "",
    active = false,
  }
  return player
end
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
function create_popup()
  local popup = awful.popup {
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
  return popup
end

-- Update widgets based on active player
function update_widgets()
  log("Update widgets called")
  local title = "󰎇 "
  local artist = "󰠃 "
  local album = "󰀥 "
  local playing = false
  if active_player ~= "" and active_player ~= nil and players[active_player] ~= nil then
    local player = players[active_player]
    title = title .. player.title
    artist = artist .. player.artist
    album = album .. player.album
    playing = player.active
  else
    title = title .. "Nothing playing."
    artist = artist .. "Nothing playing."
    album = album .. "Nothing playing."
  end

  if active_player ~= "" then
    player_widget:set_markup_silently(active_player)
  else
    player_widget:set_markup_silently("No players.")
  end
  title_widget:set_markup_silently(title)
  artist_widget:set_markup_silently(artist)
  album_widget:set_markup_silently(album)
  if playing then
    status_widget:set_markup_silently("||")
  else
    status_widget:set_markup_silently("||")
  end
end

function run_updates(player_name)
  if active_player == "" and player_name ~= "" then
    active_player = player_name
  end
  if player_name == active_player  or active_player == "" then
    update_widgets()
  end
end


-- Make the details popup.
local details = create_popup()
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

-- Build the source/player selector
local player_selector = create_popup()
function update_player_selector()
  local rows = {
    layout = wibox.layout.fixed.vertical,
  }
  if players ~= {} then
    for p, _ in pairs(players) do
      if players[p] ~= nil then
        local row = create_row(build_textbox(p))
        row.buttons = awful.button({}, 1, nil, function()
          active_player = p
          run_updates(p)
          player_selector.visible = false
        end)
        row:connect_signal("mouse::enter", function(c)
          c:set_bg(theme.bg_focus)
          c:set_fg(theme.fg_focus)
        end)
        row:connect_signal("mouse::leave", function(c)
          c:set_bg(theme.bg_normal)
          c:set_fg(theme.fg_normal)
        end)
        table.insert(rows, row)
      end
    end
  end
  player_selector:setup(rows)
  player_selector.visible = true
end
player_widget.buttons = awful.button({}, 1, nil, function()
  if player_selector.visible then
    player_selector.visible = false
  else
    update_player_selector()
  end
end)

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  log("Metadata get")
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
  run_updates(player_name)
end)
playerctl:connect_signal("playback_status", function(_, playing, player_name)
  local player = {}
  if players[player_name] == nil then
    player = new_player(player_name)
  else
    player = players[player_name]
  end
  player.active = playing
  players[player_name] = player
  run_updates(player_name)
end)

-- Connect something for when there's no players left. 
playerctl:connect_signal("no_players", function(_)
  for k, _ in players do
    players[k] = nil
  end
  active_player = ""
  run_updates(active_player)
end)


-- Build the final widgets. 
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
log("Returning Widget")
return wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 8,
  player_widget, condensed_widget, controls_widget,
}
