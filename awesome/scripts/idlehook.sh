#!/usr/bin/env bash
xautolock -time 5 -locker "betterlockscreen -l -u $HOME/.config/awesome/themes/catppuccin/catppuccin-screensaver.png" -killtime 10 -killer "systemctl suspend" &
