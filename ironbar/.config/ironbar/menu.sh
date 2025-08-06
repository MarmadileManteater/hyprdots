#/bin/bash

# pidof doesn't work right when called by ironbar
session_exists=$(tmux list-sessions | grep wofi)
if [[ "$session_exists" != "" ]]
then
  tmux kill-session -twofi
else
  $HOME/.config/hypr/scripts/run-in-tmux.sh wofi "wofi --conf ~/.config/wofi/config.conf && exit"
fi