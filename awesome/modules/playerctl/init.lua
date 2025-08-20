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
  awful.spawn(cmd)
end
function playerctl:previous()
  local cmd = self._private.cmd .. "previous"
  awful.spawn(cmd)
end
function playerctl:next()
  local cmd = self._private.cmd .. "next"
  awful.spawn(cmd)
end
function playerctl:set_loop_status(loop_status)
  local cmd = self._private.cmd .. "loop " .. loop_status
  self._private.loop_status = loop_status
  awful.spawn(cmd)
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
function playerctl:get_players(callback)
  awful.spawn.easy_async("playerctl -l", function(line)
    log_message("Call the Callback\n")
    callback(line)
  end)
end
function playerctl:get_metadata(callback)
  local keys = {
    "title",
    "artist",
    "mpris:artUrl",
    "playerName",
    "album",
  }
  local cmd = string.format(self._private.cmd .. "-f '{{%s}}' metadata", table.concat(keys, "}};{{"))
  awful.spawn.easy_async(cmd, function(line)
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
    if title and title ~= "" then
      if art_url ~= "" then
        local art_path = os.tmpname()
        save_image_async(art_url, art_path, function()
          callback(title, artist, art_path, album, player_name)
        end)
      else
        callback(title, artist, "", album, player_name)
      end
    end
  end)
end
function playerctl:get_position(callback)
  local pcmd = self._private.cmd .. "position"
  local lcmd = self._private.cmd .. "metadata mpris:length"
  awful.spawn.easy_async(pcmd, function(pos)
    awful.spawn.easy_async(lcmd, function(len)
      local l = tonumber(length)
      local p = tonumber(position)
      if l and p then
        if p >= 0 and l >= 0 then
          callback(p, l / 1000000)
        end
      end
    end)
  end)
end

function playerctl:get_status(callback)
  local cmd = self._private.cmd .. "status"
  awful.spawn.easy_async(cmd, function(line)
    local s = false
    if line:find("Playing") then s = true end
    callback(s)
  end)
end
function playerctl:get_loop_status(callback)
  awful.spawn.easy_async(cmd, function(line)
    self._private.loop_status = line
    callback(line:lower())
  end)
end
function playerctl:get_shuffle_status(callback)
  local cmd = self._private.cmd .. "shuffle"
  awful.spawn.easy_async(cmd, function(line)
    local s = false
    if line:find("On") then s = true end
    self._private.shuffle = s
    callback(s)
  end)
end
function parse_args(self, args)
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

  return ret
end

function playerctl.mt:__call(...)
  return new(...)
end

awful.spawn.with_shell("killall playerctl")

return setmetatable(playerctl, playerctl.mt)
