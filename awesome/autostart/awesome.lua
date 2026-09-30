local awful = require("awful")

local user = require("config.user")

-- Some basic default awesomewm starters
awful.spawn.once("xset s " .. user.sleep_time .. " " .. user.sleep_time)
awful.spawn.once("xss-lock --transfer-sleep-lock -- betterlockscreen -l &")
awful.spawn.once("autorandr --change")
awful.spawn.once("picom")

-- This one's an interesting bit, cause it needs to be killed first.
awful.spawn.easy_async_with_shell("pkill -f caffeine", function(stdout, stderr, exitreason, exitcode)
	awful.spawn.with_shell("caffeine &")
end)
