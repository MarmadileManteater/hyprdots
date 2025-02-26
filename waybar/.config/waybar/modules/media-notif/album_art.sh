#!/bin/bash
album_art=$(playerctl metadata mpris:artUrl)
if [[ -z $album_art ]] 
then
   rm /tmp/cover.jpeg
fi
local_uri="${album_art:7}"
magick $local_uri /tmp/cover.jpeg&
echo "/tmp/cover.jpeg"