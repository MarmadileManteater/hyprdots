#!/bin/bash

mainMods=("SUPER" "ALT_L")

function get_current_main_mod() {
  local kb_options=$(cat ~/.hyprdots/hypr/.config/hypr/hyprland.conf | grep 'kb_options = \(.*\)#' -o)
  local value="${kb_options:13:-1}"
  if [[ "$value" == "altwin:swap_alt_win" ]]
  then
    echo "ALT_L"
  else
    echo "SUPER"
  fi
}

function set_current_main_mod() {
  local set_to=$1
  if [ "$set_to" == "SUPER" ]
  then
    set_to=""
  fi
  if [ "$set_to" == "ALT_L" ]
  then
    set_to="altwin:swap_alt_win"
  fi
  sed 's@kb_options = .*#@kb_options = '$set_to'#@g' ~/.hyprdots/hypr/.config/hypr/hyprland.conf -i
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
