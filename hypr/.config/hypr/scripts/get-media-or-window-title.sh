#!/bin/bash

music="$($HOME/.config/hypr/scripts/get-media-playing-title.sh $1)"
output=""
if [ "$music" == "" ]
then
  output="$($HOME/.config/hypr/scripts/get-focused-window-title.sh)"
else
  output=$music
fi

echo "${output:0:1}    ${output:2}"