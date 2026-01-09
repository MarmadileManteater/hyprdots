#!/bin/bash

length=$1

icon=""

artist=$(playerctl metadata --format '{{artist}}')
track=$(playerctl metadata --format '{{title}}')
status=$(playerctl status)
if [ "$status" == "Playing" ]
then
  icon=""
else
  icon=""
fi

if [ "$artist" != "" ]
then
  if [ "$track" != "" ]
  then
    data="$icon $artist - $track"
    # if the artist name is inserted into the track by the software, discard it
    if [ "$(echo "$track" | grep "\- $artist" -o )" != "" ]
    then
      data="$icon $track"
    fi
  else
    data="$icon $artist"
  fi
elif [ "$track" != "" ]
then
  data="$icon $track"
fi

if [ "$length" != "" ]
then 
  echo $data | awk -v len=$length '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }'
else
  echo $data
fi