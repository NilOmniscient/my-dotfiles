#!/bin/bash
if [ "$(dunstctl is-paused)" == "true" ]; then
  echo " 󱏧 "
elif [ "$(dunstctl count history)" == "0" ]; then 
  echo " 󰂚 "
else
  echo " 󱅫 "
fi
