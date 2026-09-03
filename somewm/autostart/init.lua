local awesome = require("awesome")
local awful = require("awful")
local user = require("config.user")

for _, application in ipairs(user.autostart) do
	awful.spawn(application)
end

for _, application in ipairs(user.autostart_once) do
	awful.spawn.once(application)
end
