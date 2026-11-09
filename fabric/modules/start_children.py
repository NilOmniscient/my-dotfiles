from fabric import Fabricator
from fabric.widgets.box import Box
from fabric.widgets.image import Image
from fabric.widgets.label import Label

from gi.repository import Playerctl

from helpers.display_helper import detect_display_server

import psutil
import subprocess

max_chars = 24
icon_size = 16


class StartChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(spacing=5, **kwargs)

        self.now_playing = Label(
            label="󰝚 Nothing Playing",
            ellipsization="end",
            max_chars_width=max_chars,
            style_classes=["module"],
        )
        # Handle playerctl stuff.
        self.player_manager = Playerctl.PlayerManager()
        self.active_player = None

        def on_metadata(player, metadata):
            if player == self.active_player:
                keys = metadata.keys()
                if "xesam:artist" in keys and "xesam:title" in keys:
                    self.now_playing.set_label(
                        f"󰝚 {metadata['xesam:title']} - {metadata['xesam:artist'][0]}"
                    )

        def track_player(player):
            if self.active_player != player:
                self.active_player = player
                on_metadata(player, player.props.metadata)

        def on_playback_status_changed(player, status):
            track_player(player)

        def init_player(name):
            player = Playerctl.Player.new_from_name(name)
            player.connect("playback-status", on_playback_status_changed)
            player.connect("metadata", on_metadata)
            self.player_manager.manage_player(player)

        def on_name_appeared(manager, name):
            init_player(name)

        def on_player_vanished(manager, player):
            if self.active_player == player:
                if self.player_manager.props.players:
                    track_player(self.player_manager.props.players[0])
                else:
                    self.active_player = None
                    self.now_playing.set_label("󰝚 Nothing Playing")

        self.player_manager.connect("name_appeared", on_name_appeared)
        for name in self.player_manager.props.player_names:
            init_player(name)
        if self.player_manager.props.players:
            track_player(self.player_manager.props.players[0])

        # Build two fabricators, one for active window title, and the other for active window class
        window_name_cmd = (
            "wdotool --backend wlroots getwindowname $(wdotool --backend wlroots getactivewindow)"
            if detect_display_server() == "wayland"
            else "xdotool getwindowname $(xdotool getactivewindow)"
        )
        window_icon_cmd = (
            "wdotool --backend wlroots getwindowclassname $(wdotool --backend wlroots getactivewindow)"
            if detect_display_server() == "wayland"
            else "xdotool getwindowclassname $(xdotool getactivewindow)"
        )
        self.window_title = Label(
            label="Desktop",
            ellipsization="end",
            max_chars_width=max_chars,
        )
        self.window_icon = Image(icon="", icon_size=icon_size)
        self.active_window = Box(
            style_classes=["module"], children=[self.window_icon, self.window_title]
        )
        self.title_poll = Fabricator(
            interval=1000,
            default_value="",
            poll_from=lambda f: subprocess.run(
                window_name_cmd,
                capture_output=True,
                text=True,
                check=False,
                shell=True,
            ),
            on_changed=lambda f, v: self.window_title.set_label(f"{v.stdout.strip()}"),
        )
        self.icon_poll = Fabricator(
            interval=1000,
            default_value="",
            poll_from=lambda f: subprocess.run(
                window_icon_cmd,
                capture_output=True,
                text=True,
                check=False,
                shell=True,
            ),
            on_changed=lambda f, v: self.window_icon.set_from_icon_name(
                f"{v.stdout.strip()}", (icon_size)
            ),
        )
        self.children = [self.active_window, self.now_playing]
