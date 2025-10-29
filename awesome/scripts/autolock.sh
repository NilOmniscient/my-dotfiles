#!/bin/bash
if command -v $HOME/.cargo/bin/xidlehook &>/dev/null
then
  killall xidlehook
  $HOME/.cargo/bin/xidlehook --detect-sleep \
    --not-when-audio \
    --not-when-fullscreen \
    --timer 600 'betterlockscreen -l' '' \
    --timer 1200 'loginctl suspend' '' \
    --socket /tmp/xidle.sock
else
  xautolock -time 5 \
    -locker 'betterlockscreen -l' \
    -killtime 5 \
    -killer 'loginctl suspend' \
    -detectsleep
fi
