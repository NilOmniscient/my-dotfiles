from fabric.system_tray.widgets import SystemTray
from fabric.widgets.box import Box


class BarEnd(Box):
    def __init__(self, icon_size, **kwargs):
        super().__init__(spacing=5, **kwargs)
        self.children = [SystemTray(style_classes=["module"], icon_size=icon_size)]
