#!/bin/bash
$XDG_SESSION_TYPE # wayland | x11
active_window=""
max_len=29
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  active_window=`wlrctl toplevel list state:active`
  active_window="${active_window%%:*}"
else
  active_window=`xdotool getactivewindow getwindowclassname`
fi
echo "$active_window"
