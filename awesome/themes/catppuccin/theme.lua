-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------
local gears = require("gears")

local themes_path = require("gears.filesystem").get_configuration_dir() .. "themes/"
local dpi = require("beautiful.xresources").apply_dpi

local icons = "/usr/share/icons/breeze-dark/"

-- {{{ Main
local theme = {}
theme.wallpaper = themes_path .. "catppuccin/catppuccin-background.png"
-- }}}

-- {{{ Wrapped Widget Colors
theme.wrapped_bg = "#1E1E2E"
theme.wrapped_fg = "#4E6B99"
-- }}}

-- {{{ Styles
theme.font = "hack 14"

-- {{{ Colors -- Base these off Catppuccin Mocha
theme.bg_normal = "#1E1E2E"
theme.bg_focus = "#4E6B99"
theme.bg_urgent = "#F38BA8"
theme.bg_minimize = "#585B70"
theme.bg_systray = theme.wrapped_bg

theme.fg_normal = "#CDD6F4"
theme.fg_focus = "#CDD6F4" -- "#121212"
theme.fg_urgent = theme.bg_normal
theme.fg_minimize = theme.bg_normal

-- }}}

-- {{{ Borders
theme.useless_gap = dpi(5)
theme.border_width = dpi(2)
theme.border_normal = theme.bg_focus
theme.border_focus = "#24E3E0"
theme.border_marked = "#A6E3A1"
-- }}}

-- {{{ TagList
theme.taglist_bg_occupied = "#45475A"
theme.taglist_shape = gears.shape.rounded_rect
theme.taglist_shape_border_width = 2
theme.taglist_shape_border_color = theme.bg_focus
theme.taglist_shape_border_color_focus = theme.border_focus
-- }}}

-- {{{ TaskList
theme.tasklist_bg_normal = "#45475A"
theme.tasklist_shape = gears.shape.rounded_rect
theme.tasklist_shape_border_width = 2
theme.tasklist_shape_border_color = theme.bg_focus
theme.tasklist_shape_border_color_focus = theme.border_focus
-- }}}

theme.wibox_bg_normal = "#FFFFFF"

-- {{{ Titlebars
theme.titlebar_bg_focus = "#4E6B99"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = dpi(15)
theme.menu_width = dpi(100)
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel = themes_path .. "catppuccin/taglist/squarefz.png"
theme.taglist_squares_unsel = themes_path .. "catppuccin/taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon = themes_path .. "catppuccin/awesome-icon.png"
theme.menu_submenu_icon = icons .. "actions/24/go-next.svg"
-- }}}

-- {{{ Layout
theme.layout_tile = themes_path .. "catppuccin/layouts/tile.png"
theme.layout_tileleft = themes_path .. "catppuccin/layouts/tileleft.png"
theme.layout_tilebottom = themes_path .. "catppuccin/layouts/tilebottom.png"
theme.layout_tiletop = themes_path .. "catppuccin/layouts/tiletop.png"
theme.layout_fairv = themes_path .. "catppuccin/layouts/fairv.png"
theme.layout_fairh = themes_path .. "catppuccin/layouts/fairh.png"
theme.layout_spiral = themes_path .. "catppuccin/layouts/spiral.png"
theme.layout_dwindle = themes_path .. "catppuccin/layouts/dwindle.png"
theme.layout_max = themes_path .. "catppuccin/layouts/max.png"
theme.layout_fullscreen = themes_path .. "catppuccin/layouts/fullscreen.png"
theme.layout_magnifier = themes_path .. "catppuccin/layouts/magnifier.png"
theme.layout_floating = themes_path .. "catppuccin/layouts/floating.png"
theme.layout_cornernw = themes_path .. "catppuccin/layouts/cornernw.png"
theme.layout_cornerne = themes_path .. "catppuccin/layouts/cornerne.png"
theme.layout_cornersw = themes_path .. "catppuccin/layouts/cornersw.png"
theme.layout_cornerse = themes_path .. "catppuccin/layouts/cornerse.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus = icons .. "actions/24/window-close.svg"
theme.titlebar_close_button_normal = icons .. "actions/24/window-close.svg"

theme.titlebar_minimize_button_normal = icons .. "actions/24/window-minimize.svg"
theme.titlebar_minimize_button_focus = icons .. "actions/24/window-minimize.svg"

theme.titlebar_ontop_button_focus_active = icons .. "actions/24/window-keep-below.svg"
theme.titlebar_ontop_button_normal_active = icons .. "actions/24/window-keep-below.svg"
theme.titlebar_ontop_button_focus_inactive = icons .. "actions/24/window-keep-above.svg"
theme.titlebar_ontop_button_normal_inactive = icons .. "actions/24/window-keep-above.svg"

theme.titlebar_sticky_button_focus_active = icons .. "actions/24/window-unpin.svg"
theme.titlebar_sticky_button_normal_active = icons .. "actions/24/window-unpin.svg"
theme.titlebar_sticky_button_focus_inactive = icons .. "actions/24/window-pin.svg"
theme.titlebar_sticky_button_normal_inactive = icons .. "actions/24/window-pin.svg"

theme.titlebar_floating_button_focus_active = icons .. "actions/24/window-duplicate.svg"
theme.titlebar_floating_button_normal_active = icons .. "actions/24/window-duplicate.svg"
theme.titlebar_floating_button_focus_inactive = icons .. "actions/24/window.svg"
theme.titlebar_floating_button_normal_inactive = icons .. "actions/24/window.svg"

theme.titlebar_maximized_button_focus_active = icons .. "actions/24/window-restore.svg"
theme.titlebar_maximized_button_normal_active = icons .. "actions/24/window-restore.svg"
theme.titlebar_maximized_button_focus_inactive = icons .. "actions/24/window-maximize.svg"
theme.titlebar_maximized_button_normal_inactive = icons .. "actions/24/window-maximize.svg"
-- }}}
-- }}}

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
