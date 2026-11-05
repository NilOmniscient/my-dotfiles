#!/bin/bash
$XDG_SESSION_TYPE # wayland | x11
active_window="unknown window"
max_len=24
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  active_window=`wlrctl toplevel list state:active`
  active_window="$(echo $active_window | cut -d":" -f2)"
else
  active_window=`xdotool getactivewindow getwindowclassname`
fi
if [ ${#active_window} -gt $max_len ]; then
  active_window="${active_window:0:$max_len}..."
fi
echo "$active_window"
