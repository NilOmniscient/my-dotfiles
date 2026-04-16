-- Only matters for somewm.
local is_somewm = awesome.release == "somewm"
if is_somewm then
	-- See if there's an external connected.
	local builtin_only = true
	for o in output do
		if o.name ~= "eDP-1" then
			builtin_only = false
		end
	end
	if builtin_only then
		return
	end
	-- Set up monitors.
	-- First, handle DP-1
	output.get_by_name("DP-10").mode = { width = 1920, height = 1080, refresh = 60 }
	output.get_by_name("DP-10").position = { x = 0, y = 0 }

	-- Then, DP-2
	output.get_by_name("DP-9").mode = { width = 1920, height = 1080, refresh = 60 }
	output.get_by_name("DP-9").position = { x = 1920, y = 0 }

	-- Finally, disable eDP
	output.get_by_name("eDP-1").enabled = false

	local primary_output = output.get_by_name("DP-9")
	for s in screen do
		if s.output == primary_output then
			screen.primary = s
		end
	end
end
return
-- TODO: Flag this file as "Dirty" in git so updates don't change it after initial commit

