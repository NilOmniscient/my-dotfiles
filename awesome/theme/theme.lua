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

local color = {
	bg = "#1e1e2e", -- Base in palette
	fg = "#cdd6f4", -- Text in palette
	grey1 = "#313244", -- Surface 0
	grey2 = "#45475a", -- Surface 1
	red = "#f38ba8",
	soft_red = "#f38ba8",
	green = "#a6e3a1",
	soft_green = "#a6e3a1",
	yellow = "#f9e2af",
	soft_yellow = "#f9e2af",
	blue = "#89b4fa",
	soft_blue = "#74c7ec", -- Sapphire
	soft_blue2 = "#89dceb", -- Sky
	purple = "#cba6f7", -- Mauve
	soft_purple = "#b4befe", -- Lavender
	pink = "#f5c2e7",
	white = "#bac2de", -- Subtext 1
	white2 = "#a6adc8", -- Subtext 0
	orange = "#fab287", -- Peach
	soft_orange = "#fab287",
}

local theme = {}

theme.font = "sans 8"
theme.font_family = "Hack Nerd Font"
theme.font_size = function(size, style)
	return theme.font_family .. " " .. (style and (style .. " ") or "") .. size
end
theme.font = theme.font_size(10)
theme.primary_color = color.soft_purple
theme.primary_color_hover = color.purple
theme.active = color.green
theme.active_hover = color.soft_green
theme.accent = color.yellow
theme.accent_hover = color.soft_yellow
theme.highlight = color.blue
theme.highlight_hover = color.soft_blue
theme.urgent = color.red
theme.urgent_hover = color.soft_red
theme.fg_dim = color.grey1 -- secondary text: dates, hints, muted status lines

-- Some spacing bits
theme.widget_spacing = dpi(10)

-- Global shape setting: "rectangle" or "rounded"
-- Change this single setting to switch all widget corners
theme.shape_style = "rectangle"
theme.corner_radius = 12 -- Only used when shape_style = "rounded"

-- Helper function to get the appropriate shape
-- Usage: beautiful.shape(cr, w, h) or beautiful.shape
function theme.shape(cr, w, h)
	if theme.shape_style == "rounded" then
		gears.shape.rounded_rect(cr, w, h, theme.corner_radius)
	else
		gears.shape.rectangle(cr, w, h)
	end
end

-- Smaller radius shape for inner elements (buttons, toggles, etc.)
function theme.shape_small(cr, w, h)
	if theme.shape_style == "rounded" then
		gears.shape.rounded_rect(cr, w, h, math.min(theme.corner_radius / 2, 6))
	else
		gears.shape.rectangle(cr, w, h)
	end
end

-- AwesomeWM required
theme.bg_normal = color.bg
theme.bg_focus = color.grey2
theme.bg_urgent = color.soft_red
theme.bg_minimize = color.grey1
theme.bg_systray = color.bg

theme.fg_normal = color.fg
theme.fg_focus = color.white
theme.fg_urgent = color.white
theme.fg_minimize = color.white

theme.snapper_gap = dpi(4)
theme.useless_gap = dpi(8)
theme.border_width = dpi(1)
theme.border_color_normal = color.bg
theme.border_color_active = color.soft_purple
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

-- Generate taglist squares:
local taglist_square_size = dpi(4)
theme.taglist_squares_sel = theme_assets.taglist_squares_sel(taglist_square_size, theme.fg_normal)
theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(taglist_square_size, theme.fg_normal)

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)

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
