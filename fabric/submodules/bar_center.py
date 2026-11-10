from fabric.widgets.box import Box
from fabric.widgets.button import Button
from fabric.widgets.datetime import DateTime

from submodules.services import DNDService


class BarCenter(Box):
    def __init__(self, dnd_service: DNDService, **kwargs):
        super().__init__(spacing=5, **kwargs)
        self.children = [
            Button(
                label="󰂚",
                h_align="center",
                v_align="center",
                style_classes=["module", "button"],
                onclick=lambda _: dnd_service.toggle_enabled(),
            ),
            DateTime(style_classes=["module"]),
        ]
