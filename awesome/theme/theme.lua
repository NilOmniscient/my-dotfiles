---------------------------
-- Default awesome theme --
---------------------------
local gears = require("gears")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local rnotification = require("ruled.notification")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local colors = require("theme.colors")
local color = colors["catppuccin_mocha"]

local theme = {}

theme.shape_style = "rounded" -- "rounded" or "rectangle"
theme.corner_radius = 12 -- Only works if shape_style == "rounded"

-- Font family builder
theme.font_family = "Hack Nerd Font"
function theme.font_size(size, style)
	return theme.font_family .. " " .. (style and (style .. " ") or "") .. size
end
theme.font = theme.font_size(10)

-- Some semantic colors
theme.primary_color = color.purple
theme.primary_color_hover = color.soft_purple
theme.active = color.green
theme.active_hover = color.soft_green
theme.accent = color.yellow
theme.accent_hover = color.soft_yellow
theme.highlight = color.blue
theme.highlight_hover = color.soft_blue
theme.urgent = color.red
theme.urgent_hover = color.soft_red
theme.fg_dim = color.grey1

-- Shape helpers
function theme.shape(cr, w, h)
	if theme.shape_style == "rounded" then
		gears.shape.rounded_rect(cr, w, h, theme.corner_radius)
	else
		gears.shape.rectangle(cr, w, h)
	end
end
function theme.shape_small(cr, w, h)
	if theme.shape_style == "rounded" then
		gears.shape.rounded_rect(cr, w, h, math.min(theme.corner_radius / 2, 6))
	else
		gears.shape.rectangle(cr, w, h)
	end
end

-- The "REQUIRED" settings
theme.bg_normal = color.bg
theme.bg_focus = color.grey2
theme.bg_urgent = color.soft_read
theme.bg_minimize = color.grey1
theme.bg_systray = color.bg

theme.fg_normal = color.fg
theme.fg_focus = color.white
theme.fg_urgent = color.white
theme.fg_minimize = color.white

theme.useless_gap = dpi(0)
theme.snapper_gap = dpi(5)
theme.border_width = dpi(1)
theme.border_color_normal = color.bg
theme.border_color_active = color.soft_orange
theme.border_color_marked = color.red

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Notification popup styling (matching dashboard/launcher)
theme.notification_bg = theme.bg_normal .. "F8" -- Semi-transparent
theme.notification_fg = theme.fg_normal
theme.notification_border_color = theme.primary_color
theme.notification_border_width = dpi(1)
theme.notification_shape = theme.shape
theme.notification_margin = dpi(12)
theme.notification_max_width = dpi(400)
theme.notification_icon_size = dpi(48)
theme.notification_spacing = dpi(8)

-- Action button styling
theme.notification_action_bg_normal = color.grey2 -- #3c3836 - darker, subtler
theme.notification_action_bg_selected = theme.primary_color
theme.notification_action_fg_normal = theme.fg_normal
theme.notification_action_fg_selected = theme.bg_normal
theme.notification_action_shape_normal = theme.shape_small
theme.notification_action_shape_selected = theme.shape_small
theme.notification_action_border_width = dpi(1)
theme.notification_action_border_color = color.grey1 -- subtle border

-- Lockscreen styling
theme.lockscreen_bg = color.bg
theme.lockscreen_fg = color.fg
theme.lockscreen_clock_fg = color.fg
theme.lockscreen_date_fg = color.grey1
theme.lockscreen_input_bg = color.grey2
theme.lockscreen_input_fg = color.fg
theme.lockscreen_input_border = theme.primary_color
theme.lockscreen_error_fg = color.soft_red

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = recolor(theme_path .. "/submenu.png", color.purple)
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus = themes_path .. "default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active = themes_path .. "default/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active = themes_path .. "default/titlebar/maximized_focus_active.png"

theme.wallpaper = themes_path .. "default/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(theme.menu_height, theme.bg_focus, theme.fg_focus)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = theme.bg_urgent, fg = theme.fg_urgent },
	})
end)

return theme
