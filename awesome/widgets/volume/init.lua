local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")

local volume_off = "󰖁"
local volume_low = "󰕿"
local volume_med = "󰖀"
local volume_max = "󰕾"

local low_threshold = 33;
local med_threshold = 66;

local current_volume = 100;

local LIST_DEVICES_CMD = [[sh -c "pacmd list-sinks; pacmd list-sources"]]

local function GET_VOLUME_CMD(device, type)
  return "pactl get-" .. type .. "-volume " .. device
end
local function INC_VOLUME_CMD(device, type, step)
  current_volume = current_volume + step
  if current_volume > 100 then current_volume = 100 end
  return "pactl set-" .. type .. "-volume " .. device .. " " .. current_volume
end
local function DEC_VOLUME_CMD(device, type, step)
  current_volume = current_volume - step
  if current_volume < 0 then current_volume = 0 end
  return "pactl set-" .. type .. "-volume " .. device .. " " .. current_volume
end
