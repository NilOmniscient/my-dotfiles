-- Only matters for somewm.
local is_somewm = awesome.release == "somewm"
if ~is_somewm then
	return
end

-- Set up monitors.
-- First, handle DisplayPort-1
output.get_by_name("DisplayPort-1").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("DisplayPort-1").transform = "270"
output.get_by_name("DisplayPort-1").position = { x = 0, y = 0 }

-- Then, DisplayPort-2
output.get_by_name("DisplayPort-2").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("DisplayPort-2").position = { x = 1080, y = 440 }

-- Finally, HDMI-A-0
output.get_by_name("HDMI-A-0").mode = { width = 1920, height = 1080, refresh = 60 }
output.get_by_name("HDMI-A-0").transform = "90"
output.get_by_name("HDMI-A-0").position = { x = 3000, y = 0 }

return
-- TODO: Flag this file as "Dirty" in git so updates don't change it after initial commit
