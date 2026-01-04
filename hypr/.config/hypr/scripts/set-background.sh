#!/bin/bash

SHORT_HELP="sets wallpaper"
HELP_ARGS="parameters:\n - path to wallpaper\n - --nautilus flag (optional) - restarts nautilus if exactly one instance instance is open"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

CALLING_FROM_NAUTILUS=0

if [[ $(echo "$@" | grep "\--nautilus") != "" ]];
then
  CALLING_FROM_NAUTILUS=1
fi

file=$1

cp "$1" $HOME/.config/hypr/background

swww img $HOME/.config/hypr/background

most_common_color=$(magick $HOME/.config/hypr/background -colors 1 -unique-colors txt: | tail -n1)
most_common_hex=$(echo $most_common_color | grep -o '#\(.*\) ')

# get the hex color as a hex number
hex_color="0x$(echo $most_common_hex | grep -o "[^#]*")"

waybar_bg="rgba(0, 0, 0, 0.25)"

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0xAFFFFF ))  == -* ]]
then
  waybar_bg="rgba(0, 0, 0, 0.5)"
fi

# set the ironbar and waybar colors based on if the wallpaper is lighter or darker
sed -i "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" ~/.config/waybar/style.css &> /dev/null
cat ~/.config/ironbar/style.css | sed "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" | tee ~/.config/ironbar/style.css &> /dev/null

nautilus_flag=""

if [ $CALLING_FROM_NAUTILUS -eq 1 ]
then
  nautilus_flag="--nautilus"
fi

pwd=$(pwd)
cd "$(dirname "$1")"
# set the accent
/bin/bash $HOME/.config/hypr/scripts/set-accent-color.sh --hex=${most_common_hex:1:6} $nautilus_flag
cd $pwd