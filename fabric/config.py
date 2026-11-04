import os

import fabric
from fabric import Application
from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.datetime import DateTime
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window


def get_display_server():
    session_type = os.environ.get('XDG_SESSION_TYPE', '').lower()
    if session_type in ['wayland', 'x11']:
        return session_type

    if 'WAYLAND_DISPLAY' in os.environ:
        return 'wayland'
    elif 'DISPLAY' in os.environ:
        return 'x11'
    return 'unknown'

class WaylandStatusBar(WaylandWindow):
    def __init(self, **kwargs):
        super().__init__(
                name="bar",
                layer="top",
                anchor="left top right",
                exclusivity="auto",
                **kwargs
            )
        self.children = CenterBox(
                name="bar-inner",
                start_children=Box(
                    name="start-container",
                    children=Label(label="Start"),
                ),
                center_children=Box(
                    name="center-container",
                    children=DateTime(),
                    ),
                end_children=Box(
                    name="end-container",
                    children=Label(label="End"),
                    ),
                )

class X11StatusBar(X11Window):
    def __init(self, **kwargs):
        super().__init__(
                name="bar",
                layer="top",
                geometry="top",
                type_hint="dock",
                **kwargs
                )
        self.date_time = DateTime()
        self.children = CenterBox(center_children=self.date_time)

if __name__ == "__main__":
    bar = WaylandStatusBar() if get_display_server() == 'wayland' else X11StatusBar()
    app = Application("bar", bar)
    app.run()
