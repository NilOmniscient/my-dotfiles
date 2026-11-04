#!/bin/bash
if [ "$(jq '.dnd_enabled' ~/.local/share/end-rs/state.json)" == "true" ]; then
  echo " 󱏧 "
else
  echo " 󰂚 "
fi
