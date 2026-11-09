from fabric import Application, Fabricator
from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.image import Image
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.x11 import X11Window

# Services
from fabric.notifications import Notifications, Notification
from fabric.system_tray.widgets import SystemTray

# Non-widgets
from fabric.utils import invoke_repeater, get_relative_path, monitor_file

# Non-fabric
import os

import sys
from typing import cast

from gi.repository import GdkPixbuf

# Custom
from modules.center_children import CenterChildren
from modules.start_children import StartChildren
from modules.helpers.display_helper import detect_display_server

max_chars = 24
bar_height = 26
icon_size = bar_height - 8
notification_width = 360
notification_image_size = 64
notification_timeout = 10 * 1000
notification_monitor = 0
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


class EndChildren(Box):
    def __init__(self, **kwargs):
        super().__init__(spacing=5, **kwargs)
        self.children = [SystemTray(style_classes=["module"], icon_size=(icon_size))]


class NotificationWidget(Box):
    def __init__(self, notification: Notification, **kwargs):
        super().__init__(
            size=(notification_width, -1),
            style_classes="notification",
            spacing=8,
            orientation="v",
            **kwargs,
        )
        self._notification = notification
        body_container = Box(spacing=4, orientation="h")
        if image_pixbuf := self._notification.image_pixbuf:
            body_container.add(
                Image(
                    pixbuf=image_pixbuf.scale_simple(
                        notification_image_size,
                        notification_image_size,
                        GdkPixbuf.InterpType.BILINEAR,
                    )
                )
            )
        body_container.add(
            Box(
                spacing=4,
                orientation="v",
                children=[
                    # a box for holding both the "summary" label and the "close" button
                    Box(
                        orientation="h",
                        children=[
                            Label(
                                label=self._notification.summary,
                                ellipsization="middle",
                            )
                            .build()
                            .add_style_class("summary")
                            .unwrap(),
                        ],
                        h_expand=True,
                        v_expand=True,
                    )
                    # add the "close" button
                    .build(
                        lambda box, _: box.pack_end(
                            Button(
                                label="󰅖",
                                v_align="center",
                                h_align="end",
                                on_clicked=lambda *_: self._notification.close(),
                            ),
                            False,
                            False,
                            0,
                        )
                    ),
                    Label(
                        label=self._notification.body,
                        line_wrap="word-char",
                        v_align="start",
                        h_align="start",
                    )
                    .build()
                    .add_style_class("body")
                    .unwrap(),
                ],
                h_expand=True,
                v_expand=True,
            )
        )

        self.add(body_container)

        if actions := self._notification.actions:
            self.add(
                Box(
                    spacing=4,
                    orientation="h",
                    children=[
                        Button(
                            h_expand=True,
                            v_expand=True,
                            label=action.label,
                            on_clicked=lambda *_, action=action: action.invoke(),
                        )
                        for action in actions
                    ],
                )
            )

        # destroy this widget once the notification is closed
        self._notification.connect(
            "closed",
            lambda *_: (
                parent.remove(self) if (parent := self.get_parent()) else None,  # type: ignore
                self.destroy(),
            ),
        )

        # automatically close the notification after the timeout period
        invoke_repeater(
            notification_timeout,
            lambda: self._notification.close("expired"),
            initial_call=False,
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
            start_children=StartChildren(),
            center_children=CenterChildren(),
            end_children=EndChildren(),
        )
        bars.append(bar)
    # Generate the notification area
    notification_builder = lambda viewport, _: notifications.connect(
        "notification_added",
        lambda notifs_service, nid: (
            viewport.add(
                NotificationWidget(
                    cast(
                        Notification,
                        notifs_service.get_notification_from_id(nid),
                    )
                )
            ),
        ),
    )

    if detect_display_server() == "wayland":
        bars.append(
            WaylandWindow(
                monitor=notification_monitor,
                margin="8px 8px 8px 8px",
                anchor="top right",
                child=Box(
                    size=2,
                    spacing=4,
                    orientation="v",
                ).build(notification_builder),
            )
        )
    else:
        bars.append(
            X11Window(
                monitor=notification_monitor,
                margin="8px 8px 8px 8px",
                anchor="top right",
                child=Box(
                    size=2,
                    spacing=4,
                    orientation="v",
                ).build(notification_builder),
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
