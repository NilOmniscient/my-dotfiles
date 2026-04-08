local awful = require("awful")
local is_somewm = awesome.release == "somewm"

-- Clean up anything that can only run once.

-- Spawn in somewm only things.
if is_somewm then
	-- Handle display arrangement
	awful.spawn("kanshi")
else
	-- Spawn in awesome only things.
	awful.spawn("autorandr")
end

-- Spawn in shared stuff.
