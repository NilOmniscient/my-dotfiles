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
