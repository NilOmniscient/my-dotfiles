#!/usr/bin/fish
xidlehook --detect-sleep \
  --not-when-audio \
  --not-when-fullscreen \
  --timer 300 \
    'betterlockscreen -l' \
    '' \
  --timer 600 \
    'loginctl suspend' \
    ''
