local is_somewm = awesome.release == "somewm"

local autostart = nil

if is_somewm then
	autostart = require(... .. ".somewm")
else
	autostart = require(... .. ".awesome")
end

return {
	autostart = autostart,
}
