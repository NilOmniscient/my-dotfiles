from fabric import Application, Fabricator
from fabric.widgets.box import Box
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window
import os
import subprocess

from gi.repository import Playerctl


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
            layer="top", anchor="left top right", exclusivity="auto", **kwargs
        )
        self.active_window = Label(label="Desktop")
        self.window_poll = Fabricator(
            interval=1000,
            default_value="",
            poll_from=lambda f: subprocess.run(
                "wdotool --backend wlroots getwindowname $(wdotool --backend wlroots getactivewindow)",
                capture_output=True,
                text=True,
                check=False,
                shell=True,
            ),
            on_changed=lambda f, v: self.active_window.set_label(f"{v.stdout.strip()}"),
        )


class XStatusBar(X11Window):
    def __init__(self, **kwargs):
        super().__init__(layer="top", geometry="top", type_hint="dock", **kwargs)
        self.active_window = Label(label="Desktop")
        self.window_poll = Fabricator(
            interval=1000,
            default_value="",
            poll_from=lambda f: subprocess.run(
                "xdotool getwindowname $(xdotool getactivewindow)",
                capture_output=True,
                text=True,
                check=False,
                shell=True,
            ),
            on_changed=lambda f, v: self.active_window.set_label(f"{v.stdout.strip()}"),
        )


class StartChildren(Box):
    def __init__(self, active_window, **kwargs):
        super().__init__(**kwargs)

        self.now_playing = Label(label="󰝚 Nothing Playing")
        # Handle playerctl stuff.
        self.player_manager = Playerctl.PlayerManager()
        self.active_player = None

        def on_metadata(player, metadata):
            if player == self.active_player:
                keys = metadata.keys()
                if "xesam:artist" in keys and "xesam:title" in keys:
                    self.now_playing.set_label(
                        f"{metadata['xesam:title']} - {metadata['xesam:artist'][0]}"
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

        self.children = [active_window, self.now_playing]


class CenterChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

        self.children = [DateTime()]


if __name__ == "__main__":
    bar = WStatusBar() if detect_display_server() == "wayland" else XStatusBar()
    bar.children = CenterBox(
        start_children=StartChildren(bar.active_window),
        center_children=CenterChildren(),
    )
    app = Application("bar", bar)
    app.run()
