from fabric.system_tray.widgets import SystemTray
from fabric.widgets.box import Box
from widgets.volume import VolumeWidget


class BarEnd(Box):
    def __init__(self, icon_size, **kwargs):
        super().__init__(spacing=5, **kwargs)
        self.children = [
            VolumeWidget(style_classes=["module"]),
            SystemTray(style_classes=["module"], icon_size=icon_size),
        ]
