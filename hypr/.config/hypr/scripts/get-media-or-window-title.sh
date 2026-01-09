#!/bin/bash

poll="$2"

keep_going=1
current_status=""

while [ $keep_going == 1 ]
do

  music="$($HOME/.config/hypr/scripts/get-media-playing-title.sh $1)"
  output=""
  if [ "$music" == "" ]
  then
    output="$($HOME/.config/hypr/scripts/get-focused-window-title.sh)"
  else
    output=$music
  fi

  if [ "$current_status" != "$output" ]
  then
    echo "${output:0:1}    $(echo "${output:2}" | sed 's@&@&amp;@g')"
    current_status=$output
  fi

  if [ "$poll" != "poll" ]
  then
    keep_going=0
  fi
done