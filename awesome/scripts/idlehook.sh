#!/usr/bin/bash
~/.cargo/bin/xidlehook --detect-sleep \
  --not-when-audio \
  --not-when-fullscreen \
  --timer 300 \
    'betterlockscreen -l' \
    '' \
  --timer 600 \
    'loginctl suspend' \
    ''
