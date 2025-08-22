#!/usr/bin/env bash
xidlehook \
  --detect-sleep \
  --not-when-audio \
  --not-when-fullscreen \
  --timer 300 'xset dpms force standby' ''\
  --timer 10 'betterlockscreen -l' ''\
  --timer 300 'systemctl suspend' ''
