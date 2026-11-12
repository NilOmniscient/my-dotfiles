from fabric.audio.service import Audio
from fabric.widgets.box import Box
from fabric.widgets.eventbox import EventBox
from fabric.widgets.label import Label


class VolumeWidget(Box):
    def __init__(self, **kwargs):
        self.label = Label(label="󰕾")
        self.audio = Audio(notify_speaker=self.on_speaker_changed)

        super().__init__(
            children=EventBox(
                events=["scroll", "button-press"],
                child=self.label,
                on_scroll_event=self.on_scroll,
                on_button_press_event=self.on_click,
            ),
            **kwargs,
        )

    def on_scroll(self, _, event):
        match event.direction:
            case 0:
                self.audio.speaker.volume += 5
            case 1:
                self.audio.speaker.volume -= 5
        self.volume_update()

    def on_click(self, _, event):
        match event.button:
            case 3:
                self.toggle_mute()
        print(event.button)

    def volume_update(self):
        if self.audio.speaker.volume < 30:
            self.label.set_label(f"󰕿 {round(self.audio.speaker.volume)}%")
        elif self.audio.speaker.volume < 70:
            self.label.set_label(f"󰖀 {round(self.audio.speaker.volume)}%")
        else:
            self.label.set_label(f"󰕾 {round(self.audio.speaker.volume)}%")

    def on_speaker_changed(self):
        if not self.audio.speaker:
            return
        self.volume_update()

    def toggle_mute(self):
        self.audio.speaker.muted = not self.audio.speaker.muted
        if self.audio.speaker.muted:
            self.label.set_label("󰝟 0%")
        else:
            self.volume_update()
