#!/bin/bash

json=$(cat $HOME/.config/hypr/data/pavucontrol.json)
existing_pid=$(echo $json | jq '.pid')
existing_focus=$(echo $json | jq '.focused_monitor')

focused_monitor=$(hyprctl activeworkspace -j | jq '.id')

should_kill=0
should_start=1

if [ "$existing_pid" != "" ]
then
  if [ "$existing_pid" == "$(pidof pavucontrol)" ]
  then
    should_kill=1
    should_start=0
  fi
fi

if [ "$existing_focus" != "$focused_monitor" ]
then
  should_start=1
fi

if [ $should_kill -eq 1 ]
then
  tmux kill-session -tpavucontrol-watcher
  kill $existing_pid
  echo "{ \"pid\" : -1, \"focused_monitor\": -1 }" > $HOME/.config/hypr/data/pavucontrol.json
fi

if [ $should_start -eq 1 ]
then
  pavucontrol --tab 3&
  pid=$(pidof pavucontrol)
  echo "{ \"pid\" : $pid, \"focused_monitor\": $focused_monitor }" > $HOME/.config/hypr/data/pavucontrol.json
  sleep 0.5
  $HOME/.config/hypr/scripts/run-in-tmux.sh pavucontrol-watcher "$HOME/.config/hypr/scripts/kill-unfocused-pavucontrol.sh && exit"
fi