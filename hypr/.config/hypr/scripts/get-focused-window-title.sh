#!/bin/bash

class_name=$(hyprctl clients -j | jq '.[] | select(.focusHistoryID==0) | .class')

result=$(cat ~/.config/hypr/maps/titles.json | jq ".[] | select(.class == $class_name)")

icon="$(echo $result | jq '.icon')"
title="$(echo $result | jq '.title')"

if [ "$result" != "" ]
then
  echo "${icon:1:-1}  ${title:1:-1}"
else
  echo "󰣆  ${class_name:1:-1}"
fi