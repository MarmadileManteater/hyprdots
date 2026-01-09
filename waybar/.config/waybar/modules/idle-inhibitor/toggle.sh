#/bin/bash

. $HOME/.config/waybar/modules/idle-inhibitor/session_name.sh

if [ "$(tmux list-sessions | grep $SESSION_NAME -o)" != "" ]
then
  tmux kill-session -t$SESSION_NAME
else
  $HOME/.config/hypr/scripts/run-in-tmux.sh $SESSION_NAME "systemd-inhibit --who=$SESSION_NAME --why=waybar cat"
fi

