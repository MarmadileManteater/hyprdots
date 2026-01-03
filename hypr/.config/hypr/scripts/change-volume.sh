#/bin/bash

direction="$1"

get_volume_result="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

current_volume="$(echo $get_volume_result | grep -oP '(?<=Volume: ).*')"

if [ "$direction" == "up" ]
then
  if [[ $(echo "$current_volume >= 1.0" | bc) -eq 1 ]]
  then
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 100%
  else
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+
  fi
fi

if [ "$direction" == "down" ]
then
  wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-
fi
