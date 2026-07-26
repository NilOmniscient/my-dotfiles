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

local theme = {}

-- Fonts
theme.font_name = "hack "

theme.font_sm = theme.font_name .. "12"
theme.font_md = theme.font_name .. "14"
theme.font_lg = theme.font_name .. "24"
theme.font = theme.font_md

-- SomeWM only
theme.lockscreen_font = theme.font_md
theme.lockscreen_font_large = theme.font_name .. "64"

-- Cattpuccin Colors
-- Base --
theme.xcolorcrust = "#11111b"
theme.xcolormantle = "#181825"
theme.xcolorbase = "#1E1E2E"

-- Surface --
theme.xcolorS0 = "#313244"
theme.xcolorS1 = "#45475a"
theme.xcolorS2 = "#585b70"

-- Overlay --
theme.xcolorO0 = "#6c7086"
theme.xcolorO1 = "#7f849c"
theme.xcolorO2 = "#585b70"

-- Text --
theme.xcolorT0 = "#a6adc8"
theme.xcolorT1 = "#bac2de"
theme.xcolorT2 = "#cdd6f4"

-- Lavender --
theme.xcolor1 = "#b4befe"
-- Blue --
theme.xcolor2 = "#89b4fa"
-- Sapphire --
theme.xcolor3 = "#74c7ec"
-- Sky --
theme.xcolor4 = "#89dceb"
-- Teal --
theme.xcolor5 = "#94e2d5"
-- Green --
theme.xcolor6 = "#a6e3a1"
-- Yellow --
theme.xcolor7 = "#f9e2af"
-- Peach --
theme.xcolor8 = "#fab387"
-- Maroon --
theme.xcolor9 = "#eba0ac"
-- Red --
theme.xcolor10 = "#f38ba8"
-- Mauve --
theme.xcolor11 = "#cba6f7"
-- Pink --
theme.xcolor12 = "#f5c2e7"
-- Flamingo --
theme.xcolor13 = "#f2cdcd"
-- Rosewater --
theme.xcolor14 = "#f5e0dc"

-- Choose your accent
theme.accent = theme.xcolor1

-- Theme Colors
theme.transparent = "#00000000"

theme.bg_normal = theme.xcolorbase
theme.bg_focus = theme.xcolorS0
theme.bg_urgent = "#ff0000"
theme.bg_minimize = "#444444"
theme.bg_systray = theme.bg_focus

theme.fg_normal = theme.xcolorT2 --Text Color
theme.fg_focus = theme.xcolor5
theme.fg_urgent = "#ffffff"
theme.fg_minimize = "#ffffff"

theme.snap_bg = theme.xcolor5

theme.useless_gap = dpi(5)
theme.snapper_gap = dpi(5)
theme.systray_icon_spacing = 0
theme.systray_paddings = 0
theme.border_width = dpi(2)
theme.border_color_normal = theme.bg_focus
theme.border_color_active = theme.accent
theme.border_color_marked = theme.xcolor6

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

-- Theme the taglist
theme.taglist_bg_occupied = "#45475A"
theme.taglist_shape = gears.shape.rounded_rect
theme.taglist_shape_border_width = dpi(2)
theme.taglist_shape_border_color = theme.bg_focus
theme.taglist_shape_border_color_focus = theme.border_focus

-- Theme Tasklist
theme.tasklist_bg_normal = "#45475A"
theme.tasklist_shape = gears.shape.rounded_rect
theme.tasklist_shape_border_width = dpi(2)
theme.tasklist_shape_border_color = theme.bg_focus
theme.tasklist_shape_border_color_focus = theme.border_focus

-- Variables set for theming notifications:
theme.notification_position = "top_right"
theme.notification_bg = theme.bg_normal
theme.notification_fg = theme.fg_normal
theme.notification_border_width = dpi(2)
theme.notification_shape = gears.shape.rounded_rect
theme.notification_border_color = theme.bg_focus
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

-- theme.wallpaper = themes_path .. "default/background.png"

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
-- theme.icon_theme = nil
theme.icon_theme = "/usr/share/icons/Qogir-Dark"

-- Custom theme vars.
theme.panel_height = 26

-- Accent Colors
theme.accent_colors = {
	"#f5e0dc", -- Rosewater
	"#f2cdcd", -- Flamingo
	"#f5c2e7", -- Pink
	"#cba6f7", -- Mauve
	"#f38ba8", -- Red
	"#eba0ac", -- Maroon
	"#fab387", -- Peach
	"#f9e2af", -- Yellow
	"#a6e3a1", -- Green
	"#94e2d5", -- Teal
	"#89dceb", -- Sky
	"#74c7ec", -- Sapphire
	"#89b4fa", -- Blue
	"#b4befe", -- Lavender
}

-- Set different colors for urgent notifications.
rnotification.connect_signal("request::rules", function()
	rnotification.append_rule({
		rule = { urgency = "critical" },
		properties = { bg = "#ff0000", fg = "#ffffff" },
	})
end)

return theme
