local resize = require("awful.mouse.resize")
local aplace = require("awful.placement")
local wibox = require("wibox")
local beautiful = require("beautiful")
local color = require("gears.color")
local shape = require("gears.shape")
local cairo = require("lgi").cairo

local capi = {
	mouse = mouse,
	screen = screen,
	client = client,
}

local module = {
	default_distance = 8,
}
local snapper_gap = beautiful.snapper_gap or 5
local placeholder_w = nil

local function show_placeholder(geo)
	if not geo then
		if placeholder_w then
			placeholder_w.visible = false
		end
		return
	end

	placeholder_w = placeholder_w
		or wibox({
			ontop = true,
			bg = color(beautiful.snap_bg or beautiful.bg_urgent or "#ff0000"),
		})

	placeholder_w:geometry(geo)

	local img = cairo.ImageSurface(cairo.Format.A1, geo.width, geo.height)
	local cr = cairo.Context(img)

	cr:set_operator(cairo.Operator.CLEAR)
	cr:set_source_rgba(0, 0, 0, 1)
	cr:paint()
	cr:set_operator(cairo.Operator.SOURCE)
	cr:set_source_rgba(1, 1, 1, 1)

	local line_width = beautiful.snap_border_width or 5
	cr:set_line_width(beautiful.xresources.apply_dpi(line_width))

	local f = beautiful.snap_shape
		or function()
			cr:translate(line_width, line_width)
			shape.rounded_rect(cr, geo.width - 2 * line_width, geo.height - 2 * line_width, 10)
		end

	f(cr, geo.width, geo.height)

	cr:stroke()

	placeholder_w.shape_bounding = img._native
	img:finish()

	placeholder_w.visible = true
end

local function build_placement(snap)
	return aplace.scale + aplace[snap] + (aplace["maximize"] or nil)
end

local function detect_screen_edges(c, snap)
	local h, v = false, false
	local hindex, vindex = 0, 0
	local coords = capi.mouse.coords()

	local sg = c.screen.geometry

	local vloc, hloc = nil, nil

	if math.abs(coords.x) <= snap + sg.x and coords.x >= sg.x then
		h = true
		hloc = "left"
	elseif math.abs((sg.x + sg.width) - coords.x) <= snap then
		h = true
		hloc = "right"
	end

	if math.abs(coords.y) <= snap + sg.y and coords.y >= sg.y then
		v = true
		vloc = "top"
	elseif math.abs((sg.y + sg.height) - coords.y) <= snap then
		v = true
		vloc = "bottom"
	end
	return h, v, hindex, vindex, hloc, vloc
end

local current_snap = nil

local function get_geometry(hindex, vindex, hloc, vloc)
	local sw = capi.mouse.screen.workarea
	local geo = {
		x = sw.x + snapper_gap,
		y = sw.y + snapper_gap,
		width = sw.width - 2 * snapper_gap,
		height = sw.height - 2 * snapper_gap,
	}

	if hloc then
		geo.width = sw.width / 2 - 1.5 * snapper_gap
		if hloc == "left" then
			geo.x = sw.x + snapper_gap
		else
			geo.x = sw.x + sw.width / 2 + 0.5 * snapper_gap
		end
	end

	if vloc then
		geo.height = sw.height / 2 - 1.5 * snapper_gap
		if vloc == "top" then
			geo.y = sw.y + snapper_gap
		else
			geo.y = sw.y + sw.height / 2 + 0.5 * snapper_gap
		end
	end

	return geo
end

local function detect_modernsnap(c, distance, show)
	local old_snap = current_snap
	local h, v, hindex, vindex, hloc, vloc = detect_screen_edges(c, distance)

	if v or h then
		current_snap = { hindex, vindex, hloc, vloc }
	else
		current_snap = nil
	end

	if old_snap == current_snap then
		return
	end

	-- Show the expected geometry outline
	local geometry = current_snap and get_geometry(hindex, vindex, hloc, vloc)
	if show then
		show_placeholder(geometry or nil)
	end
	return geometry
end

local function apply_bettersnap(c, args, geo)
	if not current_snap then
		return
	end

	-- Remove the move offset
	args.offset = {}

	placeholder_w.visible = false
	return build_placement(current_snap)(c, {
		to_percent = 1,
		bounding_rect = geo,
	})
end

local geometry = { x = 0, y = 0, width = 100, height = 100 }
-- Enable edge snapping
resize.add_move_callback(function(c, geo, args)
	-- Screen edge snapping (bettersnap)
	if (module.edge_enabled ~= false) and args and (args.snap == nil or args.snap) then
		local geotmp = detect_modernsnap(c, 30, true)
		if geotmp then
			geometry = geotmp
		end
	end
end, "mouse.move")

-- Apply the snap
resize.add_leave_callback(function(c, _, args)
	if module.edge_enabled == false then
		return
	end
	return apply_bettersnap(c, args, geometry)
end, "mouse.move")

-- awful.mouse.add_leave_callback adds a callback executed when the mousegrabber
-- stops.

return setmetatable(module, {
	__call = function(_, ...)
		return module.snap(...)
	end,
})
