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

function split(str, delim)
  delim = delim or "%s"
  local t = {}
  for s in string.gmatch(str, "([^" .. delim .. "]+)") do
    table.insert(t, s)
  end
  return t
end

local utils = {}
function utils.extract_sinks_and_sources(pacmd_output)
  local sinks = {}
  local sources = {}
  local device
  local properties
  local ports
  local in_sink = false
  local in_source = false
  local in_device = false
  local in_properties = false
  local in_ports = false
  for line in pacmd_output:gmatch("[^\r\n]+") do
    if string.match(line, 'source%(s%) available.') then
      in_sink = false
      in_source = true
    end
    if string.match(line, 'sink%(s%) available.') then
      in_sink = true
      in_source = false
    end

    if string.match(line, 'index:') then
      in_device = true
      in_properties = false
      device = {
        id = line:match(': (%d+)'),
        is_default = string.match(line, '*') ~= nil
      }
      if in_sink then
        table.insert(sinks, device)
      elseif in_source then
        table.insert(sources, device)
      end
    end

    if string.match(line, '^\tproperties:') then
      in_device = false
      in_properties = true
      properties = {}
      device['properties'] = properties
    end

    if string.match(line, 'ports:') then
      in_device = false
      in_properties = false
      in_ports = true
      ports = {}
      device['ports'] = ports
    end

    if string.match(line, 'active port:') then
      in_device = false
      in_properties = false
      in_ports = false
      device['active_port'] = line:match(': (.+)'):gsub('<', ''):gsub('>', '')
    end

    if in_device then
      local t = split(line, ': ')
      local key = t[1]:gsub('\t+', ''):lower()
      local value = t[2]:gsub('^<', ''):gsub('>$', '')
      device[key] = value
    end

    if in_properties then
      local t = split(line, '=')
      local key = t[1]:gsub('\t+', ''):gsub('%.', '_'):gsub('-', '_'):gsub(':', ''):gsub("%s+$", "")
      local value
      if t[2] == nil then
        value = t[2]
      else
        value = t[2]:gsub('"', ''):gsub("^%s+", ""):gsub(' Analog Stereo', '')
      end
      properties[key] = value
    end

    if in_ports then
      local t = split(line, ': ')
      local key = t[1]
      if key ~= nil then
        key = key:gsub('\t+', '')
      end
      ports[key] = t[2]
    end
  end

  return sinks, sources
end

local volume = {}
local rows = { layout = wibox.layout.fixed.vertical }

local osd_popup = awful.popup({
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect,
  border_width = 1,
  border_color = theme.fg_focus,
  maximum_width = 400,
  offset = { y = 5 },
  widget = {},
})

function osd_popup.toggle()
  if (osd_popup.visible) then
    osd_popup.visible = false
  else
    local active_screen = awful.screen.focused()
    awful.placement.centered(osd_popup, {
      parent = active_screen,
    })
    osd_popup.visible = true
  end
end

local sink_popup = awful.popup({
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  ontop = true,
  visible = false,
  shape = gears.shape.rounded_rect,
  border_width = 1,
  border_color = theme.fg_focus,
  maximum_width = 400,
  offset = { y = 5 },
  widget = {},
})
function sink_popup.toggle()
  if (sink_popup.visible) then
    sink_popup.visible = false
  else
    local active_screen = awful.screen.focused()
    awful.placement.centered(sink_popup, {
      parent = active_screen,
    })
    sink_popup.visible = true
  end
end
