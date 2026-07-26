local awful = require("awful")
local is_somewm = awesome.release == "somewm"

-- Clean up anything that can only run once.

-- Spawn in somewm only things.
if is_somewm then
	-- Handle display arrangement
	awful.spawn("kanshi")
else
	-- First, kill all duplicate spawn instances
	awful.spawn("killall xidlehook")
	awful.spawn("killall c")
	awful.spawn("killall bluetoothctl")
	-- Spawn in awesome only things.
	awful.spawn("autorandr")
	awful.spawn("picom")
	awful.spawn("caffeine")
	awful.spawn("numlockx on")
	awful.spawn(
		'xautolock -detectsleep -time 5 -locker "betterlockscreen -l" -notify 30 -notifier "notify-send -u normal -t 10000 -- \'LOCKING screen in 30 seconds\'"'
	)
	awful.spawn('xidlehook --not-when-fullscreen --detect-sleep --not-when-audio --timer 600 "systemctl suspend" -')
end

-- Spawn in shared stuff.
