-- Things to run before AwesomeWM really loads up. (e.g. autorand, or xrandr)
local awful = require("awful")
-- awful.spawn.with_shell("autorandr -c")
awful.spawn_with_shell("gentoo-pipewire-launcher restart")
