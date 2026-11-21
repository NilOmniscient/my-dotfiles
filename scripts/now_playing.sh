#!/bin/bash
now_playing=`playerctl metadata --format "{{title}} - {{artist}}" | cut -c 1-26`

echo "󰝚 $now_playing... 󰝚 "
