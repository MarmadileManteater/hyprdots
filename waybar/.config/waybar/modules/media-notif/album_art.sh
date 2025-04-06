#!/bin/bash
album_art=$(playerctl metadata mpris:artUrl)
if [[ "$album_art" != "" ]]
then
   if [[ "$album_art" != "$(cat /tmp/recent_cover.txt)" ]]
   then
      echo "$album_art" >> /tmp/recent_cover.txt
      local_uri="${album_art:7}"

      magick $local_uri /tmp/cover.jpeg&
   fi
   echo "/tmp/cover.jpeg"
else
   if [[ -f "/tmp/cover.jpeg" ]]
   then
      rm /tmp/recent_cover.txt
      rm /tmp/cover.jpeg
   fi
fi