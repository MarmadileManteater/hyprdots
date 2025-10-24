#!/bin/bash

mainMods=("SUPER" "ALT_L")

function get_current_main_mod() {
  local value=$(cat ~/.hyprdots/hypr/.config/hypr/hyprland.conf | grep '$mainMod = \(.*\)#' -o)
  echo ${value:10:-1}
}

function set_current_main_mod() {
  local set_to=$1
  if [ "$set_to" == "" ]
  then
    set_to="SUPER"
  fi
  sed 's@$mainMod = .*#@$mainMod = '$1'#@g' ~/.hyprdots/hypr/.config/hypr/hyprland.conf -i
}

mainMod=$(get_current_main_mod)
if [ "$mainMod" == "${mainMods[0]}" ]
then
  set_current_main_mod ${mainMods[1]}
  notify-send "Flipping mainMod to ${mainMods[1]}"
elif [ "$mainMod" == "${mainMods[1]}" ]
then
  set_current_main_mod ${mainMods[0]}
  notify-send "Flipping mainMod to ${mainMods[0]}"
fi
