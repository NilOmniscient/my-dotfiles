-- somewmrc.lua - Default configuration for somewm (AwesomeWM on Wayland)
--
-- Copy this file to ~/.config/somewm/rc.lua and customize it.
-- Press Mod4+s to see all keybindings.
--
-- Coming from AwesomeWM on X11? See docs/reference/deviations for the Wayland
-- differences (no xprop/xdotool/picom, xkb is compositor-side, etc.). The
-- public Lua API is preserved; X11-specific tooling is what changes.

-- First, require the config
local config = require("config")

-- Next, require keybindings
require("binds")
require("autostart")

-- Begin adding AwesomeWM files
local awful = require("awful")
require("awful.autofocus")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Error handling
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)

-- Show notification if we fell back due to X11-specific patterns in user config
if awesome.x11_fallback_info then
	gears.timer.delayed_call(function()
		local info = awesome.x11_fallback_info
		local msg = string.format(
			"Your config was skipped because it contains X11-specific code that "
				.. "won't work on Wayland.\n\n"
				.. "File: %s:%d\n"
				.. "Pattern: %s\n"
				.. "Code: %s\n\n"
				.. "Suggestion: %s\n\n"
				.. "Edit your rc.lua to remove X11 dependencies, then restart somewm.",
			info.config_path or "unknown",
			info.line_number or 0,
			info.pattern or "unknown",
			info.line_content or "",
			info.suggestion or "See somewm migration guide"
		)
		naughty.notification({
			urgency = "critical",
			title = "Config contains X11 patterns - using fallback",
			message = msg,
			timeout = 0,
		})
	end)
end

-- Theme: persisted in ~/.config/somewm/theme, defaults to gruvbox
local theme_file = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/somewm/theme"
local theme_name = "gruvbox"
do
	local f = io.open(theme_file, "r")
	if f then
		local name = f:read("*l")
		if name and name ~= "" then
			theme_name = name
		end
		f:close()
	end
end

-- Simple theme switcher that writes the selected theme to a file and restarts somewm.
local function switch_theme(name)
	local dir = (os.getenv("XDG_CONFIG_HOME") or os.getenv("HOME") .. "/.config") .. "/somewm"
	os.execute("mkdir -p " .. dir)
	local f = io.open(theme_file, "w")
	if f then
		f:write(name .. "\n")
		f:close()
	end
	awesome.restart()
end

beautiful.init(gears.filesystem.get_themes_dir() .. theme_name .. "/theme.lua")

-- Lockscreen (must be after beautiful.init)
require("lockscreen").init()

-- Defaults
-- Change these to your preferred terminal and editor, or use xdg-terminal and xdg-editor if available.
local terminal = config.user.terminal
local editor = config.user.editor
local editor_cmd = terminal .. " -e " .. editor
local modkey = "Mod4"

-- ============================================================
-- User customization (uncomment to enable)
-- ============================================================

-- Keyboard layout / xkb options (somewm-side, no setxkbmap needed).
-- awful.input.xkb_layout  = "us"
-- awful.input.xkb_variant = ""
-- awful.input.xkb_options = "caps:escape"

-- Pointer / touchpad (libinput-backed; see awful.input for the full list).
-- awful.input.tap_to_click      = 1
-- awful.input.natural_scrolling = 1
-- awful.input.pointer_speed     = 0.5

-- Per-monitor fractional scaling.
-- output.connect_signal("added", function(o)
--     if o.name == "HDMI-A-1" then o.scale = 1.5 end
-- end)

-- Autostart (idempotent across reloads). somewm provides notifications and
-- wallpapers natively, so don't run mako/swaybg/dunst.
-- awful.spawn.once("nm-applet")        -- network tray
-- awful.spawn.once("blueman-applet")   -- bluetooth tray
-- awful.spawn.once("udiskie --tray")   -- auto-mount removable drives

-- Auto-lock after N seconds of idle.
-- awesome.set_idle_timeout("auto-lock", 600, function() awesome.lock() end)

-- Inhibit idle while presenting / watching a long video. Combines with
-- protocol-level inhibitors (mpv, browsers); see awesome.idle_inhibited
-- for the OR'd state.
-- awful.keyboard.append_global_keybindings({ awful.key {
--     modifiers = { modkey, "Shift" }, key = "i",
--     on_press = function() awesome.idle_inhibit = not awesome.idle_inhibit end,
--     description = "toggle idle inhibit", group = "awesome",
-- } })

-- Animated layout transitions (somewm-specific). Tiled clients fly smoothly
-- between positions on layout changes, mwfact tweaks, client spawn/close, etc.
-- local layout_anim = require("somewm.layout_animation")
-- layout_anim.duration = 0.15
-- layout_anim.easing   = "ease-out-cubic"

-- Custom IPC commands. After reload, callable as:
--   somewm-client run focused-tag
-- awful.ipc.register("focused-tag", function()
--     local t = awful.screen.focused().selected_tag
--     return t and t.name or ""
-- end)

-- Menu
local theme_menu = {
	{
		"gruvbox",
		function()
			switch_theme("gruvbox")
		end,
	},
	{
		"catppuccin",
		function()
			switch_theme("catppuccin")
		end,
	},
	{
		"nord",
		function()
			switch_theme("nord")
		end,
	},
}

local menu_items = {
	{
		"hotkeys",
		function()
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{
		"terminal",
		function()
			awful.spawn(terminal)
		end,
	},
	{ "theme", theme_menu },
	{ "edit config", editor_cmd .. " " .. awesome.conffile },
	{ "restart", awesome.restart },
	{
		"lock",
		function()
			awesome.lock()
		end,
	},
	{
		"quit",
		function()
			awesome.quit()
		end,
	},
}

mymainmenu = awful.menu({ items = { { "somewm", menu_items, beautiful.awesome_icon }, { "open terminal", terminal } } })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon, menu = mymainmenu })

menubar.utils.terminal = terminal

-- Layouts
-- Signal-driven layout registration. Fires once at startup; config code appends
-- to the layouts list so multiple chunks (defaults + user additions) can compose.
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts(config.user.layouts)
end)

-- Wallpaper
screen.connect_signal("request::wallpaper", function(s)
	local colors = beautiful.wallpaper_colors
	if colors then
		local dpi = beautiful.xresources.apply_dpi
		local logo_size = dpi(200)
		local logo_color = beautiful.wallpaper_logo_color
		local logo_path = gears.filesystem.get_themes_dir() .. "../icons/somewm-logo.svg"

		-- Recolor logo to match theme
		local logo_widget = nil
		if logo_color then
			local logo_image = gears.color.recolor_image(logo_path, logo_color)
			logo_widget = {
				{
					image = logo_image,
					forced_height = logo_size,
					forced_width = logo_size,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			}
		end

		awful.wallpaper({
			screen = s,
			bg = {
				type = "linear",
				from = { 0, 0 },
				to = { s.geometry.width, s.geometry.height },
				stops = { { 0, colors[1] }, { 1, colors[2] } },
			},
			widget = logo_widget,
		})
	elseif beautiful.wallpaper then
		awful.wallpaper({
			screen = s,
			widget = {
				{
					image = beautiful.wallpaper,
					upscale = true,
					downscale = true,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				tiled = false,
				widget = wibox.container.tile,
			},
		})
	else
		awful.wallpaper({ screen = s, bg = beautiful.bg_normal or "#222222" })
	end
end)

-- Tag persistence across monitor hotplug
-- The save handler lives in awful.permissions.tag_screen and stores tag
-- metadata into awful.permissions.saved_tags keyed by connector name.
-- To disable or replace it:
--   tag.disconnect_signal("request::screen", awful.permissions.tag_screen)

-- Wibar

local mytextclock = wibox.widget({
	{
		{
			format = "%a %b %d  %H:%M",
			widget = wibox.widget.textclock,
		},
		left = dpi(8),
		right = dpi(8),
		widget = wibox.container.margin,
	},
	bg = beautiful.clock_bg or beautiful.bg_focus,
	shape = function(cr, w, h)
		gears.shape.rounded_rect(cr, w, h, dpi(4))
	end,
	widget = wibox.container.background,
})

-- Fires once per screen at startup AND on monitor hotplug. Restore saved tags
-- if this connector was previously seen; otherwise create the default set.
screen.connect_signal("request::desktop_decoration", function(s)
	-- Restore saved tags if this output was previously removed
	local output_name = s.output and s.output.name
	local restore = output_name and awful.permissions.saved_tags[output_name]
	if restore then
		awful.permissions.saved_tags[output_name] = nil
		local client_tags = {}
		for _, td in ipairs(restore) do
			local t = awful.tag.add(td.name, {
				screen = s,
				layout = td.layout,
				master_width_factor = td.master_width_factor,
				master_count = td.master_count,
				gap = td.gap,
				selected = td.selected,
			})
			for _, c in ipairs(td.clients) do
				if c.valid then
					if not client_tags[c] then
						client_tags[c] = {}
					end
					table.insert(client_tags[c], t)
				end
			end
		end
		for c, tags in pairs(client_tags) do
			c:move_to_screen(s)
			c:tags(tags)
		end
	else
		awful.tag({ "dev", "web", "chat", "files", "media" }, s, awful.layout.layouts[1])
	end

	s.mypromptbox = awful.widget.prompt()

	s.mylayoutbox = awful.widget.layoutbox({
		screen = s,
		buttons = {
			awful.button({}, 1, function()
				awful.layout.inc(1)
			end),
			awful.button({}, 3, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 4, function()
				awful.layout.inc(-1)
			end),
			awful.button({}, 5, function()
				awful.layout.inc(1)
			end),
		},
	})

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({ modkey }, 1, function(t)
				if client.focus then
					client.focus:move_to_tag(t)
				end
			end),
			awful.button({}, 3, awful.tag.viewtoggle),
			awful.button({ modkey }, 3, function(t)
				if client.focus then
					client.focus:toggle_tag(t)
				end
			end),
			awful.button({}, 4, function(t)
				awful.tag.viewprev(t.screen)
			end),
			awful.button({}, 5, function(t)
				awful.tag.viewnext(t.screen)
			end),
		},
	})

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = {
			awful.button({}, 1, function(c)
				c:activate({ context = "tasklist", action = "toggle_minimization" })
			end),
			awful.button({}, 3, function()
				awful.menu.client_list({ theme = { width = 250 } })
			end),
			awful.button({}, 4, function()
				awful.client.focus.byidx(-1)
			end),
			awful.button({}, 5, function()
				awful.client.focus.byidx(1)
			end),
		},
		layout = {
			spacing = dpi(4),
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{ id = "icon_role", widget = awful.widget.clienticon },
					id = "icon_margin_role",
					left = dpi(6),
					right = dpi(2),
					top = dpi(4),
					bottom = dpi(4),
					widget = wibox.container.margin,
				},
				{
					{ id = "text_role", widget = wibox.widget.textbox },
					id = "text_margin_role",
					right = dpi(6),
					widget = wibox.container.margin,
				},
				layout = wibox.layout.fixed.horizontal,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	s.mywibox = awful.wibar({
		position = "top",
		screen = s,
		widget = {
			layout = wibox.layout.stack,
			{
				layout = wibox.layout.align.horizontal,
				{
					layout = wibox.layout.fixed.horizontal,
					mylauncher,
					s.mytaglist,
					s.mypromptbox,
					s.mytasklist,
				},
				{ widget = wibox.container.background },
				{
					layout = wibox.layout.fixed.horizontal,
					wibox.widget.systray(),
					s.mylayoutbox,
				},
			},
			{
				mytextclock,
				halign = "center",
				widget = wibox.container.place,
			},
		},
	})
end)
