#!/bin/bash

. $HOME/.config/waybar/modules/idle-inhibitor/session_name.sh
current_state=""
while [ true ]
do

  is_active="false"
  icon="inactive"

  if [ "$(tmux list-sessions | grep -o $SESSION_NAME )" != "" ]
  then
    is_active="true"
    icon="active"
  fi

  if [ "$current_state" != "$is_active" ]
  then
    echo "{ \"is_active\": $is_active, \"alt\": \"$icon\" }"
    current_state="$is_active"
  fi
done
