#!/usr/bin/env bash
xautolock -time 5 -locker "betterlockscreen -l" -killtime 10 -killer "systemctl suspend" &
