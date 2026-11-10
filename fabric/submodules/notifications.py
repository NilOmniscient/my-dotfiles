# Fabric
from fabric.notifications import Notifications, Notification
from fabric.utils import invoke_repeater
from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.image import Image
from fabric.widgets.label import Label
from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.window import Window
from fabric.widgets.x11 import X11Window


# From GObject
from gi.repository import GdkPixbuf

from submodules.helpers import detect_display_server
from submodules.services import DNDService

from typing import cast

do_not_disturb: DNDService
notification_width = 360
notification_image_size = 64
notification_timeout = 10 * 1000
notification_monitor = 0

is_wayland = detect_display_server() == "wayland"
window_type = WaylandWindow if is_wayland else X11Window


class NotificationCenter:
    def __init__(self):
        self.x = 1


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


def create_notification_area(
    notifications: Notifications,
    dnd_service: DNDService,
    width,
    image_size,
    timeout,
    monitor,
) -> Window:
    global \
        do_not_disturb, \
        notification_width, \
        notification_image_size, \
        notification_timeout, \
        notification_monitor
    do_not_disturb = dnd_service
    notification_width = width
    notification_image_size = image_size
    notification_timeout = timeout
    notification_monitor = monitor

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
            )
            if not do_not_disturb.get_enabled()
            else None
        ),
    )
    return window_type(
        monitor=notification_monitor,
        margin="8px 8px 8px 8px",
        anchor="top right",
        child=Box(
            size=2,
            spacing=4,
            orientation="v",
        ).build(notification_builder),
    )
