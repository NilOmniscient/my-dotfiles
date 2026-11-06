import psutil
from fabric import Application, Fabricator
from fabric.widgets.box import Box
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.image import Image
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window

# Non-widgets
from fabric.system_tray.widgets import SystemTray
from fabric.utils import get_relative_path
import os
import subprocess

from gi.repository import Playerctl

max_chars = 24
bar_height = 26
icon_size = bar_height - 8


def detect_display_server():
    session_type = os.environ.get("XDG_SESSION_TYPE", "").lower()
    if session_type in ["wayland", "x11"]:
        return session_type
    if os.environ.get("WAYLAND_DISPLAY"):
        return "wayland"
    elif os.environ.get("DISPLAY"):
        return "x11"
    return session_type or "unknown"


class WStatusBar(WaylandWindow):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar",
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            **kwargs,
        )


class XStatusBar(X11Window):
    def __init__(self, **kwargs):
        super().__init__(
            name="bar", layer="top", geometry="top", type_hint="dock", **kwargs
        )


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


class CenterChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.children = [
            Label(label=" 󰂚 ", style_classes=["module"]),
            DateTime(style_classes=["module"]),
        ]


class EndChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.children = [SystemTray(style_classes=["module"], icon_size=(icon_size))]


if __name__ == "__main__":
    bar = WStatusBar() if detect_display_server() == "wayland" else XStatusBar()
    bar.children = CenterBox(
        name="bar-inner",
        start_children=StartChildren(),
        center_children=CenterChildren(),
        end_children=EndChildren(),
    )
    app = Application("bar", bar)
    app.set_stylesheet_from_file(get_relative_path("./styles.css"))
    app.run()
