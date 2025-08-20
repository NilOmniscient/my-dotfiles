local theme = require("beautiful")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")

local playerctl_module = require("modules.playerctl")
local playerctl = playerctl_module()

local log_message = function(s)
  local filepath = "/home/bwhittington/adv_media.log"
  local file = io.open(filepath, "a")
  if file then
    file:write(s)
    file:close()
  end
end
local function build_row(w)
  local row = wibox.widget {
    widget = wibox.container.background,
    fg = theme.fg_normal,
    bg = theme.bg_normal,
    {
      layout = wibox.container.margin,
      margins = 8,
      w
    }
  }
  return row
end
local function build_textbox(text)
  return wibox.widget {
    widget = wibox.widget.textbox,
    font = theme.font,
    text = text,
  }
end


local active_source = ""
local source_selector = awful.popup {
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  shape = gears.shape.rounded_rect,
  border_color = theme.bg_focus,
  border_width = 1,
  maximum_width = 200,
  offset = { y = 5 },
  ontop = true,
  visible = false,
  widget = {},
}
local source_text = wibox.widget {
  widget = wibox.widget.textbox,
  text = "Source",
  ellipsize = "end",
  maximum_width = 100,
}
local function build_sources(player_names)
  local has_name = false
  local rows = { layout = wibox.layout.fixed.vertical }
  for name in player_names:gmatch("[^\r\n]+") do
    if not has_name then
      has_name = true
      if source_text.text == "Source" then
        active_source = name
        source_text:set_text(name)
      end
    end

    local row = build_row(build_textbox(name))
    row.buttons = awful.button({}, 1, nil, function()
      active_source = name
      source_selector.visible = false
      source_text:set_text(name)
      playerctl:set_player(active_source)
    end)
    row:connect_signal("mouse::enter", function(c)
      c:set_bg(theme.bg_focus)
      c:set_fg(theme.fg_focus)
    end)
    row:connect_signal("mouse::leave", function(c)
      c:set_bg(theme.bg_normal)
      c:set_fg(theme.fg_normal)
    end)
    table.insert(rows, row)
  end
  source_selector:setup(rows)
  if not has_name then
    source_text:set_text("Source")
    active_source = ""
    playerctl:set_player(active_source)
  end
end

source_text.buttons = awful.button({}, 1, nil, function()
  if not source_selector.visible then
    playerctl:get_players(build_sources)
    source_selector:move_next_to(mouse.current_widget_geometry)
  else
    source_selector.visible = false
  end
end)

-- Control buttons and widget.
local function build_button(text, callback)
  local btn = build_textbox(text)
  btn.buttons = awful.button({}, 1, nil, function()
    callback()
  end)
  return btn
end

local repeat_button = build_textbox("󰑗")
local function update_repeat(status)
  if status == "None" then
    repeat_button:set_text("󰑗")
  elseif status == "Track" then
    repeat_button:set_text("󰑘")
  else
    repeat_button:set_text("󰑖")
  end
end
repeat_button.buttons = awful.button({}, 1, nil, function()
  playerctl:cycle_loop_status(update_repeat)
end)

local shuffle_button = build_textbox("󰒞")
local function update_shuffle(status)
  if status then
    shuffle_button:set_text("󰒟")
  else
    shuffle_button:set_text("󰒞")
  end
end
shuffle_button.buttons = awful.button({}, 1, nil, function()
  playerctl:toggle_shuffle(update_shuffle)
end)

-- Build out the info widgets. 
local song_title = build_textbox("󰝚 Nothing playing")
song_title.ellipsize = "end"
song_title.forced_width = 300
local full_title = build_textbox("󰝚 Nothing playing")
local song_artist = build_textbox("󰠃 Nothing Playing")
local song_album = build_textbox("󰲹 Nothing Playing")
local album_art = wibox.widget {
  widget = wibox.widget.imagebox,
  forced_width = 80,
  forced_height = 80,
}

local function update_metadata(title, artist, art_path, album, _)
  if title == "" then
    title = "󰝚 Nothing playing"
  end
  song_title:set_text("󰝚 " .. title)
  full_title:set_text("󰝚 " .. title)
  if artist == "" then
    artist = "󰠃 Nothing Playing"
  end
  song_artist:set_text("󰠃 " .. artist)
  if album == "" then
    album = "󰲹 Nothing Playing"
  end
  song_album:set_text("󰲹 " .. album)
  if art_path == "" then
    album_art:set_image(nil)
  else
    album_art:set_image(art_path)
  end
end

local status_widget = build_textbox("󰐊")
local function update_status(status)
  if status then
    status_widget:set_text("󰐊")
  else
    status_widget:set_text("󰏤")
  end
end

-- Build the details popup. 
local details_popup = awful.popup {
  bg = theme.bg_normal,
  fg = theme.fg_normal,
  shape = gears.shape.rounded_rect,
  border_color = theme.bg_focus,
  border_width = 1,
  maximum_width = 600,
  offset = { y = 5 },
  ontop = true,
  visible = false,
  widget = {},
}
local function build_details_popup()
  local details_rows = {
    layout = wibox.layout.fixed.vertical,
  }
  local container = wibox.widget {
    layout = wibox.layout.fixed.horizontal,
    album_art,
    spacing = 8,
    {
      layout = wibox.layout.fixed.vertical,
      spacing = 8,
      full_title,
      song_artist,
      song_album,
    },
  }
  table.insert(details_rows, build_row(container))
  details_popup:setup(details_rows)
end

song_title.buttons = awful.button({}, 1, nil, function()
  if not details_popup.visible then
    details_popup:move_next_to(mouse.current_widget_geometry)
    details_popup.visible = true
  else
    details_popup.visible = false
  end
end)

local function update_widgets()
  playerctl:get_metadata(update_metadata)
  playerctl:get_loop_status(update_repeat)
  playerctl:get_shuffle_status(update_shuffle)
  playerctl:get_status(update_status)
end

local controls = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 8,
  build_button("󰒮", function() playerctl:previous() end),
  build_button("󰐎", function() playerctl:toggle() end),
  build_button("󰒭", function() playerctl:next() end),
  repeat_button,
  shuffle_button,
}

-- Make a timer that calls the update function.
gears.timer {
  call_now = true,
  singleshot = true,
  callback = function()
    build_details_popup()
    playerctl:get_players(build_sources)
  end,
}
gears.timer {
  timeout = 0.35,
  autostart = true,
  call_now = true,
  callback = function()
    update_widgets()
  end,
}

local final_widget = wibox.widget {
  layout = wibox.layout.fixed.horizontal,
  spacing = 16,
  source_text,
  status_widget,
  song_title,
  controls,
}
return final_widget
