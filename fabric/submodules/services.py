from fabric.core.service import Service, Signal, Property


class DNDService(Service):
    @Signal
    def dnd_changed(self, new_value: bool) -> None: ...

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.enabled = False

    def get_enabled(self) -> bool:
        return self.enabled

    def set_enabled(self, new_value: bool) -> None:
        self.enabled = new_value
        self.dnd_changed(new_value)

    def toggle_enabled(self) -> None:
        self.enabled = not self.enabled
        self.dnd_changed(self.enabled)
