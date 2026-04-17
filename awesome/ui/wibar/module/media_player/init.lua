local awful = require("awful")
local theme = require("beautiful")
local wibox = require("wibox")

local tmp_path = os.tmpname()
local art_path = ""

local final_widget = wibox.widget({
	layout = wibox.layout.fixed.horizontal,
	{
		widget = wibox.container.margin,
		wibox.widget.textbox(" 󰝚 "),
	},
})
local song_title = wibox.widget({
	widget = wibox.widget.textbox,
	font = theme.font,
	forced_height = 16,
	text = "",
})
local song_artist = wibox.widget({
	widget = wibox.widget.textbox,
	font = theme.font,
	forced_height = 16,
	text = "",
})
local song_album = wibox.widget({
	widget = wibox.widget.textbox,
	font = theme.font,
	forced_height = 16,
	text = "",
})
local title_watcher = awful.widget.watch('playerctl metadata --format "󰝚  {{title}}"', 5, function(widget, stdout)
	if stdout == "" then
		song_title:set_text("󰝚  Nothing Playing")
	else
		song_title:set_text(stdout)
	end
end)

local artist_watcher = awful.widget.watch('playerctl metadata --format "󰠃  {{artist}}"', 5, function(widget, stdout)
	if stdout == "" then
		song_artist:set_text("󰠃  Nothing Playing")
	else
		song_artist:set_text(stdout)
	end
end)

local album_watcher = awful.widget.watch('playerctl metadata --format "󰀥  {{album}}"', 5, function(widget, stdout)
	if stdout == "" then
		song_album:set_text("󰀥  Nothing Playing")
	else
		song_album:set_text(stdout)
	end
end)

local album_art = wibox.widget({
	widget = wibox.widget.imagebox,
	forced_width = 80,
	forced_height = 80,
})

local album_watcher = awful.widget.watch('playerctl metadata --format "{{mpris:artUrl}}"', 5, function(widget, stdout)
	if stdout == "" then
		art_path = ""
		widget:set_image(nil)
	else
		-- Download the image, and update the path.
		if stdout ~= art_path then
			-- If the art path isn't the same, update the art data.
			art_path = stdout
			local art_url = art_path:gsub("%\n", "")
			awful.spawn.with_line_callback(string.format("curl -L -s %s -o %s", art_url, tmp_path), {
				exit = function()
					if tmp_path == "" then
						album_art:set_image(nil)
					else
						album_art:set_image(tmp_path)
					end
				end,
			})
		end
	end
end)
local details_container = {
	layout = wibox.layout.fixed.vertical,
}
local details_content = wibox.widget({
	widget = wibox.container.background,
	fg = theme.fg_normal,
	bg = theme.bg_normal,
	{
		layout = wibox.container.margin,
		margins = 8,
		{
			layout = wibox.layout.fixed.horizontal,
			album_art,
			spacing = 8,
			{
				layout = wibox.layout.flex.vertical,
				song_title,
				song_artist,
				song_album,
			},
		},
	},
})
local popup = awful.popup({
	bg = theme.bg_normal,
	fg = theme.fg_normal,
	border_color = theme.bg_focus,
	border_width = 1,
	maximum_width = 600,
	offset = { y = 5 },
	ontop = true,
	visible = false,
	widget = {},
})

table.insert(details_container, details_content)
popup:setup(details_container)

final_widget:buttons(awful.util.table.join(awful.button({}, 1, nil, function()
	if not popup.visible then
		popup:move_next_to(mouse.current_widget_geometry)
		popup.visible = true
	else
		popup.visible = false
	end
end)))

return final_widget
