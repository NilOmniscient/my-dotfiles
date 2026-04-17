local awful = require("awful")
local gears = require("gears")
local theme = require("beautiful")
local wibox = require("wibox")

local calendar_widget = {}

--- Create the calendar section
function calendar_widget.create()
	-- Calendar styling functions
	local function decorate_cell(widget, flag, date)
		-- Style the original widget based on cell type
		if flag == "header" then
			-- Month/Year header
			widget.font = theme.font
			widget.markup = '<span color="' .. (theme.bg_focus or "#d65d0e") .. '">' .. (widget.text or "") .. "</span>"
			return widget
		elseif flag == "weekday" then
			-- Day names
			widget.font = theme.font
			widget.markup = '<span color="'
				.. (theme.fg_normal or "#ebdbb2")
				.. '88">'
				.. (widget.text or "")
				.. "</span>"
			return widget
		elseif flag == "focus" then
			-- Today - orange background (no forced size, let it match other cells)
			widget.font = theme.font
			return wibox.widget({
				widget,
				bg = theme.bg_focus or "#d65d0e",
				fg = theme.bg_normal or "#282828",
				shape = theme.shape_small,
				widget = wibox.container.background,
			})
		elseif flag == "blank" then
			-- Empty cells
			return widget
		else
			-- Normal days and other month days
			widget.font = theme.font
			if flag ~= "normal" then
				-- Other month days - dimmed
				widget.markup = '<span color="'
					.. (theme.fg_normal or "#ebdbb2")
					.. '44">'
					.. (widget.text or "")
					.. "</span>"
			end
			return widget
		end
	end

	-- Create the calendar
	local cal = wibox.widget({
		{
			date = os.date("*t"),
			font = theme.font,
			spacing = 4,
			start_sunday = false,
			long_weekdays = false,
			fn_embed = decorate_cell,
			flex_height = true,
			widget = wibox.widget.calendar.month,
		},
		halign = "center",
		widget = wibox.container.place,
	})

	-- Navigation buttons
	local prev_button = wibox.widget({
		{
			text = "󰅁",
			font = theme.font,
			halign = "center",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.background,
	})

	local next_button = wibox.widget({
		{
			text = "󰅂",
			font = theme.font,
			halign = "center",
			widget = wibox.widget.textbox,
		},
		widget = wibox.container.background,
	})

	local today_button = wibox.widget({
		{
			text = "Today",
			font = theme.font,
			halign = "center",
			widget = wibox.widget.textbox,
		},
		fg = theme.bg_focus or "#d65d0e",
		widget = wibox.container.background,
	})

	-- Current displayed date (for navigation)
	local displayed_date = os.date("*t")

	-- Update calendar display
	local function update_calendar()
		cal.date = {
			year = displayed_date.year,
			month = displayed_date.month,
			day = os.date("*t").day, -- Keep today highlighted
		}
	end

	-- Navigation actions
	prev_button:buttons(gears.table.join(awful.button({}, 1, function()
		displayed_date.month = displayed_date.month - 1
		if displayed_date.month < 1 then
			displayed_date.month = 12
			displayed_date.year = displayed_date.year - 1
		end
		update_calendar()
	end)))

	next_button:buttons(gears.table.join(awful.button({}, 1, function()
		displayed_date.month = displayed_date.month + 1
		if displayed_date.month > 12 then
			displayed_date.month = 1
			displayed_date.year = displayed_date.year + 1
		end
		update_calendar()
	end)))

	today_button:buttons(gears.table.join(awful.button({}, 1, function()
		displayed_date = os.date("*t")
		update_calendar()
	end)))

	-- Hover effects
	for _, btn in ipairs({ prev_button, next_button, today_button }) do
		btn:connect_signal("mouse::enter", function()
			btn.fg = theme.bg_urgent or "#fe8019"
		end)
		btn:connect_signal("mouse::leave", function()
			btn.fg = btn == today_button and (theme.bg_focus or "#d65d0e") or theme.fg_normal
		end)
	end

	return wibox.widget({
		{
			{
				text = "Calendar",
				font = theme.font,
				widget = wibox.widget.textbox,
			},
			nil,
			{
				prev_button,
				today_button,
				next_button,
				spacing = 12,
				layout = wibox.layout.fixed.horizontal,
			},
			layout = wibox.layout.align.horizontal,
		},
		{
			cal,
			top = 8,
			widget = wibox.container.margin,
		},
		spacing = 8,
		layout = wibox.layout.fixed.vertical,
	})
end

return calendar_widget
