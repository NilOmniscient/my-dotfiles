-- Interface for working with playerctl
local awful = require("awful")
local gears = require("gears")
local theme = require("beautiful")

local log_message = function(s)
  local filepath = "/home/bwhittington/playerctl.log"
  local file = io.open(filepath, "a")
  if file then
    file:write(s)
    file:close()
  end
end

local playerctl = {
  mt = {}
}

function save_image_async(url, filepath, callback)
  awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", url, filepath),
    {
      exit = callback
    }
  )
end

-- Playerctl controls
function playerctl:set_player(player)
  if player and player ~= "" then
    self.player = player
    self._private.cmd = "playerctl -p " .. player .. " "
  else
    self.player = ""
    self._private.cmd = "playerctl "
  end
end

function playerctl:toggle()
  local cmd = self._private.cmd .. "play-pause"
  awful.spawn.with_shell(cmd)
end
function playerctl:previous()
  local cmd = self._private.cmd .. "previous"
  awful.spawn.with_shell(cmd)
end
function playerctl:next()
  local cmd = self._private.cmd .. "next"
  awful.spawn.with_shell(cmd)
end
function playerctl:set_loop_status(loop_status)
  local cmd = self._private.cmd .. "loop " .. loop_status
  self._private.loop_status = loop_status
  awful.spawn.with_shell(cmd)
end
function playerctl:cycle_loop_status()
  local loop_status = self._private.loop_status or "None"
  local new_status = loop_status
  if loop_status == "None" then
    new_status = "Track"
  elseif loop_status == "Track" then
    new_status = "Playlist"
  else
    new_status = "None"
  end
  self:set_loop_status(new_status)
end
function playerctl:toggle_shuffle()
  local shuffle = self._private.shuffle == "on" and true or false
  self._private.shuffle = not shuffle
  local cmd = self._private.cmd .. "shuffle " .. shuffle
  awful.spawn.with_shell(cmd)
end

-- Getter/Emitters
local function get_players(self)
  local cmd = "playerctl -l"
  awful.spawn.easy_async(cmd, function(line, _, _, _)
    local player_names = {}
    -- Need to split up the lines. 
    if line and line ~= "" then
      --for name in line:gmatch("[^\r\n]+") do
        --if name and name ~= "" then
      log_message("Sending Signal\n" .. line)
          self:emit_signal("players", line)
          -- table.insert(player_names, name)
        --end
      --end
    end
    -- self:emit_signal("players", player_names)
  end)
end
local function get_metadata(self)
  local keys = {
    "title",
    "artist",
    "mpris:artUrl",
    "playerName",
    "album",
  }

  local cmd = string.format(self._private.cmd .. "-f '{{%s}}' metadata", table.concat(keys, "}};{{"))
  awful.spawn.easy_async(cmd, function(line, _, _, _)
    local words = gears.string.split(line, ";")
    local title = words[1] or ""
    local artist = words[2] or ""
    local art_url = words[3] or ""
    local player_name = words[4] or ""
    local album = words[5] or ""

    art_url = art_url:gsub("%\n", "")
    if player_name == "spotify" then
      art_url = art_url:gsub("open.spotify.com", "i.scdn.co")
    end

    if self._private.metadata_timer and self._private.metadata_timer.started then
      self._private.metadata_timer:stop()
    end

    if title and title ~= "" then
      if art_url ~= "" then
        local art_path = os.tmpname()
        save_image_async(art_url, art_path, function()
          self:emit_signal("metadata", title, artist, art_path, album, player_name)
        end)
      else
        self:emit_signal("metadata", title, artist, "", album, player_name)
      end
    end
  end)
end

local function get_position(self)
  local position_cmd = self._private.cmd .. "position"
  local length_cmd = self._private.cmd .. "metadata mpris:length"

  awful.spawn.easy_async(position_cmd, function(position)
    awful.spawn.easy_async(length_cmd, function(length)
      local l = tonumber(length)
      local p = tonumber(position)
      if l and p then
        if p >= 0 and l >= 0 then
          self:emit_signal("position", p, l / 1000000)
        end
      end
    end)
  end)
end

local function get_playback_status(self)
  local status_cmd = self._private.cmd .. "status"
  awful.spawn.easy_async(status_cmd, function(line)
    local s = false
    if line:find("Playing") then s = true end
    self:emit_signal("playback_status", s)
  end)
end

local function get_loop_status(self)
  local cmd = self._private.cmd .. "loop"
  awful.spawn.easy_async(cmd, function(line)
    self._private.loop_status = line
    self:emit_signal("loop_status", line:lower())
  end)
end

local function get_shuffle_status(self)
  local cmd = self._private.cmd .. "shuffle"
  awful.spawn.easy_async(cmd, function(line)
    local s = false
    if line:find("On") then s = true end
    self._private.shuffle = s
    self:emit_signal("shuffle", s)
  end)
end

-- Emitter timers. 
local function build_timer(interval, callback)
  return gears.timer {
    timer = interval,
    autostart = true,
    callback = callback,
  }
end

local function emit_metadata(self)
  self._private.metadata_timer = build_timer(self.debounce, function() get_metadata(self) end)
end
local function emit_players(self)
  self._private.players_timer = build_timer(self.debounce, function() get_players(self) end)
end
local function emit_position(self)
  self._private.position_timer = build_timer(self.interval, function() get_position(self) end)
end
local function emit_playback_status(self)
  self._private.playback_status_timer = build_timer(self.debounce, function() get_playback_status(self) end)
end
local function emit_loop_status(self)
  self._private.loop_status_timer = build_timer(self.debounce, function() get_loop_status(self) end)
end
local function emit_shuffle_status(self)
  self._private.shuffle_status_timer = build_timer(self.debounce, function() get_shuffle_status(self) end)
end

local function parse_args(self, args)
  if args.ignore then
    self._private.cmd = self._private.cmd .. "--ignore-player="
    if type(args.ignore) == "string" then
      self._private.cmd = self._private.cmd .. args.ignore .. " "
    elseif type(args.ignore) == "table" then
      for index, player in ipairs(args.ignore) do
        self._private.cmd = self._private.cmd .. player
        if index < #args.ignore then
          self._private.cmd = self._private.cmd .. ","
        else
          self._private.cmd = self._private.cmd .. " "
        end
      end
    end
  end
end

local function new(args)
  args = args or {}

  local ret = gears.object{}
  gears.table.crush(ret, playerctl, true)
  ret.interval = args.interval or theme.playerctl_interval or 1
  ret.debounce = args.debounce or theme.playerctl_debounce or 0.35
  ret.player = ""
  ret._private = {}
  ret._private.metadata_timer = nil
  ret._private.cmd = "playerctl "
  parse_args(ret, args)

  -- Now set up the signals to emit.
  emit_players(ret)
  emit_metadata(ret)
  emit_position(ret)
  emit_playback_status(ret)
  emit_loop_status(ret)
  emit_shuffle_status(ret)
  return ret
end

function playerctl.mt:__call(...)
  return new(...)
end

awful.spawn.with_shell("killall playerctl")

return setmetatable(playerctl, playerctl.mt)
