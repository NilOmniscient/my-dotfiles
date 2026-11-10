from fabric import Application
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window
from fabric.notifications import Notifications

# Services

# Non-widgets
from fabric.utils import get_relative_path, monitor_file

# Non-fabric
import sys


# local
from submodules.bar_start import BarStart
from submodules.bar_center import BarCenter
from submodules.bar_end import BarEnd
from submodules.helpers import detect_display_server
from submodules.notifications import create_notification_area
from submodules.services import DNDService

max_chars = 24
bar_height = 26
icon_size = bar_height - 8
notification_width = 360
notification_image_size = 64
notification_timeout = 10 * 1000
notification_monitor = 0

# Launch the notifications service
do_not_disturb = DNDService()
notifications = Notifications()


class WStatusBar(WaylandWindow):
    def __init__(self, **kwargs):
        super().__init__(
            style_classes="bar",
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            **kwargs,
        )


class XStatusBar(X11Window):
    def __init__(self, **kwargs):
        super().__init__(
            style_classes="bar", layer="top", geometry="top", type_hint="dock", **kwargs
        )


if __name__ == "__main__":
    bars = []
    monitor_count = 1
    if len(sys.argv) > 1:
        monitor_count = int(sys.argv[1])
    if len(sys.argv) > 2:
        notification_monitor = int(sys.argv[2])
    for i in range(monitor_count):
        bar = (
            WStatusBar(monitor=i)
            if detect_display_server() == "wayland"
            else XStatusBar(monitor=i)
        )
        bar.children = CenterBox(
            style_classes=["bar-inner"],
            start_children=BarStart(icon_size, max_chars),
            center_children=BarCenter(dnd_service=do_not_disturb),
            end_children=BarEnd(icon_size),
        )
        bars.append(bar)
    bars.append(
        create_notification_area(
            notifications,
            do_not_disturb,
            notification_width,
            notification_image_size,
            notification_timeout,
            notification_monitor,
        )
    )
    app = Application(
        "bar",
        bars[0],
    )

    def apply_stylesheet(*_):
        return app.set_stylesheet_from_file(get_relative_path("./styles.css"))

    style_monitor = monitor_file(get_relative_path("./styles.css"))
    style_monitor.connect("changed", apply_stylesheet)
    apply_stylesheet()
    app.run()
