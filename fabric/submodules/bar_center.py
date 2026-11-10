from fabric.widgets.box import Box
from fabric.widgets.datetime import DateTime
from fabric.widgets.label import Label


class BarCenter(Box):
    def __init__(self, **kwargs):
        super().__init__(spacing=5, **kwargs)
        self.children = [
            Label(
                label="󰂚",
                h_align="center",
                v_align="center",
                style_classes=["module", "button"],
            ),
            DateTime(style_classes=["module"]),
        ]
