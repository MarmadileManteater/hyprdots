#/bin/bash

SHORT_HELP="provides options for the accent based on the wallpaper"
HELP_ARGS="parameters:\n - number (optional) - number of color choices to generate (DEFAULT 5)"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

NUM_OF_COLORS=5

if [ "$1" != "" ]
then
  NUM_OF_COLORS=$1
fi

IFS=$'\n'
image_magick_colors=($(magick $HOME/.config/hypr/background -colors $NUM_OF_COLORS -unique-colors txt:))

colors_string=""

for line in ${image_magick_colors[@]}
do
  if [ "${line:0:1}" != "#" ]
  then
    colors_string="$colors_string$(echo $line | grep "#.* " -o),"
  fi
done

IFS=$','
colors=($colors_string)

i=1
for color in ${colors[@]}
do
  echo "$i: $(echo "" | $HOME/.config/hypr/scripts/print-as-color.sh --hex=${color:1:6}) $color"
  i=$(echo "$i + 1" | bc)
done

read selection

len=$(echo "${#colors} + 2" | bc)
if [ $selection -gt 0 ]
then
  if [ $selection -lt $len ]
  then
    index=$(echo "$selection - 1" | bc)
    chosen_color=${colors[$index]}
    $HOME/.config/hypr/scripts/set-accent-color.sh --hex=${chosen_color:1:6}
    exit
  fi
fi

echo "Invalid selection"