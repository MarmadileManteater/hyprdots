#!/bin/bash

length=$1

artist=$(playerctl metadata --format '{{artist}}')
track=$(playerctl metadata --format '{{title}}')
if [ "$artist" != "" ]
then
  if [ "$track" != "" ]
  then
    data="󰝚 $artist - $track"
    # if the artist name is inserted into the track by the software, discard it
    if [ "$(echo "$track" | grep "\- $artist" -o )" != "" ]
    then
      data="󰝚 $track"
    fi
  else
    data="󰝚 $artist"
  fi
elif [ "$track" != "" ]
then
  data="󰝚 $track"
fi

if [ "$length" != "" ]
then 
  echo $data | awk -v len=$length '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }'
else
  echo $data
fi