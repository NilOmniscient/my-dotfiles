local output = require("output")
local screen = require("screen")
-- See if there's an external connected.
local builtin_only = true

-- Set up monitors.
-- First, handle DP-1
output.get_by_name("DP-1").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("DP-1").position = { x = 3000, y = 0 }
output.get_by_name("DP-1").transform = 3

-- Then, DP-2
output.get_by_name("DP-2").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("DP-2").position = { x = 0, y = 0 }
output.get_by_name("DP-2").transform = 1

-- Finally, DP-3
output.get_by_name("DP-3").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("DP-3").position = { x = 1080, y = 440 }

local primary_output = output.get_by_name("DP-3")
for s in screen do
	if s.output == primary_output then
		screen.primary = s
	end
end
return
-- TODO: Flag this file as "Dirty" in git so updates don't change it after initial commit
