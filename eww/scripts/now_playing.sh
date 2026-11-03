#!/bin/bash
max_len=29
now_playing="󰝚 `playerctl metadata title`"
if [ ${#now_playing} -gt $max_len ]; then
  now_playing="${now_playing:0:$max_len}..."
fi

echo "$now_playing"
