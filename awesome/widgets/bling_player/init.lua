local theme = require("beautiful")
local gears = require("gears")
local wibox = require("wibox")
local bling = require("modules.bling")

-- This is the object used to keep everything updated. 
local Player = {
  name = "",
  title = "",
  artist = "",
  album_path = "",
  album = "",
  status = false,
  loop_status = "",
  shuffle_status = false,
  volume = 1.0,
  position_sec = 0,
  length_sec = 1,
  -- Functions to self update. 
  set_name = function(s) self.name = s end,
  set_title = function(s) self.title = s end,
  set_artist = function(s) self.artist = s end,
  set_album_path = function(s) self.artist = s end,
  set_album = function(s) self.album = s end,
  set_status = function(b) self.status = b end,
  set_loop_status = function(s) self.loop_status = s end,
  set_shuffle_status = function(b) self.shuffle_status = b end,
  set_volume = function(n) self.volume = n end,
  set_position_sec = function(n) self.position_sec = n end,
  set_length_sec = function(n) self.length_sec = n end,
  -- Generate a new object. 
  new = function(p)
    p = p or {}
    setmetatable(p, self)
    self.__index = self
    return p
  end,
}

-- Keep a running list of active players
local players = {}

-- Keep track of actively controlled player
local active_player = ""

-- Since we have bling, the playerctl stuff is simplified. 
local playerctl = bling.signal.playerctl.lib()

-- Build the various objects we'll need. 
local art = wibox.widget {
  widget = wibox.widget.imagebox,
  image = 'default_image.png',
  resize = true,
  forced_height = dpi(30),
  forced_width = dpi(30),
}
local artist_widget = build_textbox("Nothing Playing")
local name_widget = build_textbox("No Players")
local title_widget = build_textbox("Nothing Playing")
local status_widget = build_textbox("||")

-- Control Widgets
local prev_widget = build_textbox(" 󰒮 ", function() prev() end)
local next_widget = build_textbox(" 󰒭 ", function() next() end)
local play_widget = build_textbox(" 󰐎 ", function() play() end)
local shuf_widget = build_textbox("  ", function() shuf() end)
local rept_widget = build_textbox(" 󰑖 ", function() rept() end)

local controls_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  prev_widget, play_widget, next_widget, shuf_widget, rept_widget,
}

local progress_text = wibox.widget {
  widget = wibox.widget.textbox,
  text = "00:00 / 00:00",
  font = theme.font,
}
local progress_widget = wibox.widget {
  layout = wibox.layout.stack,
  {
    widget = wibox.widget.progress_bar,
    shape = gears.shape.rounded_bar,
    value = 0.0,
    border_width = 2,
    border_color = theme.fg_normal,
    forced_width = 100,
    max_value = 1.0,
  },
  progress_text,
}

-- When a player exits, remove from the list. 
playerctl:connect_signal("exit", function(_, player_name)
  players[player_name] = nil
  -- If active player, get new active player. 
  active_player = playerctl:get_active_player()
  if active_player ~= nil then
    update_widgets(active_player)
  else
    no_players()
  end
end)

-- Handle the various signals
playerctl:connect_signal("metadata",
  function(_, title, artist, album_path, album, new, player_name)
    -- Check if this player exists. If not, create it. 
    create_player_if_not_exists(player_name)
    players[player_name].set_title(title)
    players[player_name].set_artist(artist)
    players[player_name].set_album_path(album_path)
    players[player_name].set_album(album)

    update_widgets(player_name)
  end
)

playerctl.connect_signal("loop_status", function(_, status, player_name)
  create_player_if_not_exists(player_name)
  players[player_name].set_loop_status(status)
  update_widgets(player_name)
end)

playerctl.connect_signal("playback_status", function(_, status, player_name)
  create_player_if_not_exists(player_name)
  players[player_name].set_playback_status(status)
  update_widgets(player_name)
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec, player_name)
  create_player_if_not_exists(player_name)
  players[player_name].set_position_sec(interval_sec)
  players[player_name].set_length_sec(length_sec)
  update_widgets(player_name)
end)

playerctl:connect_signal("shuffle", function(_, shuffle, player_name)
  create_player_if_not_exists(player_name)
  players[player_name].set_shuffle_status(shuffle)
  update_widgets(player_name)
end)

playerctl.connect_signal("volume", function(_, volume, player_name)
  create_player_if_not_exists(player_name)
  players[player_name].set_volume(volume)
  update_widgets(player_name)
end)

-- Special signal for when all players have exited. 
playerctl.connect_signal("no_players", function()
  no_players()
end)

-- Control functions
function prev() 
  local player = active_player
  playerctl:previous(player)
end
function next() 
  local player = active_player
  playerctl:next(player)
end
function play()
  local player = active_player
  playerctl:play_pause(player)
end
function shuf() 
  local player = active_player
  playerctl:cycle_shuffle(player)
end
function rept()
  local player = active_player
  playerctl:cycle_loop(player)
end

-- Utility Functions
function no_players()
  -- Set all players to nil. Just nuke it to oblivion. 
  for key, _ in pairs(players) do
    players[key] = nil
  end
  -- Reset all widgets to default vals. 
  art:set_image(gears.surface.load_uncached("default.png"))
  name_widget:set_markup_silently("No players")
  title_widget:set_markup_silently("Nothing playing")
  artist_widget:set_markup_silently("Nothing playing")
end

function build_textbox(markup, callback)
  callback = callback or nil
  local textbox = wibox.widget {
    widget = wibox.widget.textbox,
    markup = markup,
    align = "center",
    valign = "center",
    font = theme.font,
  }
  if callback ~= nil then
    textbox.buttons = awful.button({}, 1, nil, function()
      callback()
    end)
  end
  return textbox
end

function update_widgets(player_name)
  -- Only update if active player. 
  if player_name ~= active_player then return end
  
  -- Various glyph icons for use in some widgets
  local s_play = "|󰐊|"
  local s_stop = "|󰏤|"
  local shuf_y = " 󰒟 "
  local shuf_n = " 󰒞 "
  local rept_a = " 󰑖 "
  local rept_o = " 󰑘 "
  local rept_n = " 󰑗 "
 
  -- Update album art.
  art:set_image(gears.surface.load_uncached(players[player_name].album_path))

  -- And the widgets. 
  name_widget:set_markup_silently(players[player_name].player_name)
  title_widget:set_markup_silently("󰎇 " .. players[player_name].title)
  artist_widget:set_markup_silently("󰠃 " .. players[player_name].artist)

  -- Update context specific control icons
  if players[player_name].shuffle_status == true then
    shuf_widget:set_markup_sliently(shuf_y)
  else
    shuf_widget:set_markup_silently(shuf_n)
  end

  if players[player_name].status == true then
    status_widget:set_markup_silently(s_play)
  else
    status_widget:set_markup_silently(s_stop)
  end

  if players[player_name].loop_status == "TRACK" then
    rept_widget:set_markup_silently(rept_o)
  elseif players[player_name].loop_status == "PLAYLIST" then
    rept_widget:set_markup_silently(rept_a)
  else
    rept_widget:set_markup_silently(rept_n)
  end

  -- Update the progressbar. 
  local current = "00:00"
  local seconds = players[player_name].position_sec
  local minutes = math.floor(seconds / 60)
  seconds = seconds - (minutes * 60)
  if minutes >= 60 then
    local hours = math.floor(minutes / 60)
    minutes = minutes - (hours * 60)
    current = string.format("%02d:%02d:%02d", hours, minutes, seconds)
  else
    current = string.format("%02d:%02d", minutes, seconds)
  end
  if players[player_name].length_sec == 0 or players[player_name].length_sec == nil then
    -- For streams and the like, just display a running time.
    progress_text:set_text(current)
  else
    -- Otherwise, make it Running / Length
    -- Convert length. 
    local s = players[player_name].length_sec
    local m = math.floor(s / 60)
    s = s - (m * 60)
    local l = "00:00"
    if m >= 60 then
      local h = math.floor(m / 60)
      m = m - (h * 60)
      l = string.format("%02d:%02d:%02d", h, m, s)
    else
      l = string.format("%02d:%02d", m, s)
    end
    progress_text:set_text(current .. " / " .. l)
  end
end

function create_player_if_not_exists(player_name)
  if players[player_name] == nil then
    players[player_name] = Player:new()
  end
end
