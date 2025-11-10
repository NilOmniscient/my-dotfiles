#!/bin/bash
killall volumeicon
killall volctl
if command -v $HOME/.local/bin/volctl &>/dev/null
then
  $HOME/.local/bin/volctl
else
  volumeicon
fi
