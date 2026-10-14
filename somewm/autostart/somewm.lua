local awful = require("awful")

local user = require("config.user")

-- Some basic SomeWM starters
awesome.set_idle_timeout("lock", user.lock_time, function()
	awesome.lock()
end)
awful.spawn("kanshi &")
