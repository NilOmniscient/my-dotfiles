#!/usr/bin/env bash
xautolock -time 5 \
  -locker 'betterlockscreen -l' \
  -killtime 5 \
  -killer 'loginctl suspend' \
  -detectsleep
