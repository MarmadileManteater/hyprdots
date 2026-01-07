#!/bin/bash

album_art=$(playerctl metadata mpris:artUrl)
if [[ "$album_art" != "" ]]
then
   if [[ "$album_art" != "$(cat /tmp/recent_cover.txt)" ]]
   then
      
      echo "$album_art" > /tmp/recent_cover.txt
      local_uri="${album_art:7}"
      magick -size 150x83 xc:none -draw "roundrectangle 0,0,150,83,15,15" png:- | convert $local_uri -matte - -compose DstIn -composite /tmp/cover.png&
   fi
   echo "/tmp/cover.png"
else
   if [[ -f "/tmp/cover.png" ]]
   then
      rm /tmp/recent_cover.txt
      rm /tmp/cover.png
   fi
fi