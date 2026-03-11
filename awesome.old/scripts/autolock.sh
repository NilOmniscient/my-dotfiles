#!/bin/bash
if command -v $HOME/.cargo/bin/xidlehook &>/dev/null
then
  killall xidlehook
  $HOME/.cargo/bin/xidlehook --detect-sleep \
    --not-when-audio \
    --not-when-fullscreen \
    --timer 300 'betterlockscreen --off 180 -l' '' \
    --timer 300 'loginctl suspend' '' \
    --socket /tmp/xidle.sock
else
  xautolock -time 5 \
    -locker 'betterlockscreen --off 180 -l' \
    -detectsleep
fi
