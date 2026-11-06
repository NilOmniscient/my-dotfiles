from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window
import os


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


class XStatusBar(X11Window):
    def __init__(self, **kwargs):
        super().__init__(layer="top", geometry="top", type_hint="dock", **kwargs)


class CenterChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.children = [Label(label="Notifications"), DateTime()]


if __name__ == "__main__":
    bar = WStatusBar() if detect_display_server() == "wayland" else XStatusBar()
    bar.children = CenterBox(center_children=CenterChildren())
    app = Application("bar", bar)
    app.run()
