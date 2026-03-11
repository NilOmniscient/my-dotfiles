#!/bin/bash
if command -v $HOME/.cargo/bin/xidlehook &>/dev/null
then
  $HOME/.cargo/bin/xidlehook-client --socket /tmp/xidle.sock control --action trigger --timer 0
else
  xautolock -locknow
fi
