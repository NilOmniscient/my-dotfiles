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
