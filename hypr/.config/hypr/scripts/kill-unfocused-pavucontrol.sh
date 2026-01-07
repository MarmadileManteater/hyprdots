#!/bin/bash

while [ true ]
do
  pid=$(pidof pavucontrol)
  if [ "$pid" != "" ]
  then
    focused_class="$(hyprctl clients -j | jq '.[] | select(.focusHistoryID==0) | .class')"
    if [ "$focused_class" != "\"org.pulseaudio.pavucontrol\"" ]
    then
      kill $pid
      exit
    fi
  fi 
  sleep 1
done