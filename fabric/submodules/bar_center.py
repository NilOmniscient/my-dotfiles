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
                on_clicked=lambda b, *_: (
                    dnd_service.toggle_enabled(),
                    b.set_label("󱏨" if dnd_service.get_enabled() else "󰂚"),
                ),
            ),
            DateTime(style_classes=["module"]),
        ]
