#!/bin/bash
if command -v $HOME/.cargo/bin/xidlehook &>/dev/null
then
  killall xidlehook
  $HOME/.cargo/bin/xidlehook --detect-sleep \
    --not-when-audio \
    --not-when-fullscreen \
    --timer 600 'betterlockscreen -l' '' \
    --socket /tmp/xidle.sock
else
  xautolock -time 5 \
    -locker 'betterlockscreen -l' \
    -detectsleep
fi
