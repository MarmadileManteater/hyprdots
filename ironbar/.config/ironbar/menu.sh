#/bin/bash

# pidof doesn't work right when called by ironbar
session_exists=$(tmux list-sessions | grep rofi)
if [[ "$session_exists" != "" ]]
then
  tmux kill-session -trofi
else
  $HOME/.config/hypr/scripts/run-in-tmux.sh rofi "rofi -show drun -terminal ptyxis && exit"
fi