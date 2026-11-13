from fabric.widgets.wayland import WaylandWindow
from fabric.widgets.window import Window
from fabric.widgets.x11 import X11Window

import ast
import os
import typing

from gi.repository.Gdk import WindowTypeHint


def detect_display_server():
    session_type = os.environ.get("XDG_SESSION_TYPE", "").lower()
    if session_type in ["wayland", "x11"]:
        return session_type
    if os.environ.get("WAYLAND_DISPLAY"):
        return "wayland"
    elif os.environ.get("DISPLAY"):
        return "x11"
    return session_type or "unknown"


def get_window_type() -> type:
    if detect_display_server() == "wayland":
        return WaylandWindow
    else:
        return X11Window


def get_window_commands() -> list[str]:
    if detect_display_server() == "wayland":
        return [
            "wdotool --backend wlroots getwindowname $(wdotool --backend wlroots getactivewindow)",
            "wdotool --backend wlroots getwindowclassname $(wdotool --backend wlroots getactivewindow)",
        ]
    else:
        return [
            "xdotool getwindowname $(xdotool getactivewindow)",
            "xdotool getwindowclassname $(xdotool getactivewindow)",
        ]


def build_window(
    wlayer: str = "top",
    exclusive: bool = True,
    side: str = "top",
    **kwargs,
) -> Window:
    if detect_display_server() == "wayland":
        if side == "center-auto":
            side = "center"
        elif side == "top":
            side = "left top right"
        elif side == "right":
            side = "top right bottom"
        elif side == "bottom":
            side = "left bottom right"
        elif side == "left":
            side = "top left bottom"
        else:
            side = " ".join(side.split("-"))
        return WaylandWindow(
            layer=wlayer,
            anchor=side,
            exclusivity="auto" if exclusive else "none",
            **kwargs,
        )
    else:
        window = X11Window(
            layer=ast.literal_eval(wlayer),
            geometry=ast.literal_eval(side),
            **kwargs,
        )
        if exclusive:
            window.set_type_hint(WindowTypeHint.DOCK)
        return window
