#!/bin/bash

brightness_param=$(echo $@ | grep "\--brightness=-*[0-9]*" -o)

if [ "$brightness_param" != "" ]
then
  brightness_param="${brightness_param:13}"
  brightness_param=$(echo $brightness_param | sed 's@--*@-@g')
  if [ $brightness_param -lt -255 ]
  then
    echo "WARN: brightness maxed out; setting to -255"
    brightness_param=-255
  fi

  if [ $brightness_param -gt 255 ]
  then
    echo "WARN: brightness maxed out; setting to 255"
    brightness_param=255
  fi
else
  brightness_param=0
fi

invert_param=$(echo $@ | grep "\--invert" -o)

# allow rgb or hex input
IFS=$'\n'
colors=($($HOME/.config/hypr/scripts/normalize-color-input.sh $@ --which))

if [ ${colors[0]:0:1} != "r" ]
then
  for output in "${colors[@]}"
  do
    echo "$output"
  done
  exit
fi

rgb_param=${colors[0]}
hex_param=${colors[1]}
which_param=${colors[2]}

rgb=($(echo $rgb_param | grep '[0-9]*' -o))

new_rgb="rgb("

index=0

for channel in ${rgb[@]}
do
  if [ "$invert_param" == "" ]
  then
    value=$(echo $(echo "$channel + $brightness_param" | bc))
  else
    value=$(echo $(echo "255 - $channel" | bc))
  fi

  if [ $value -gt 255 ]
  then
    value=255
  fi

  if [ $value -lt 0 ]
  then
    value=0
  fi
  new_rgb="$new_rgb$(echo $value)"
  if [ $index -eq ${#rgb} ]
  then
    new_rgb="$new_rgb)"
  else
    new_rgb="$new_rgb,"
  fi
  index=$(echo "$index + 1" | bc)
done

$HOME/.config/hypr/scripts/rgb-to-hex.sh $new_rgb
