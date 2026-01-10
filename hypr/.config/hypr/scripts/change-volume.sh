#/bin/bash

direction="$1"
amount="$2"

if [ "$amount" == "" ]
then
  amount="5"
fi

get_volume_result="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

current_volume="$(echo $get_volume_result | grep -oP '(?<=Volume: ).*')"

if [ "$direction" == "up" ]
then
  if [[ $(echo "$current_volume >= 1.0" | bc) -eq 1 ]]
  then
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 100%
  else
    wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ $amount%+
  fi
fi

if [ "$direction" == "down" ]
then
  wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ $amount%-
fi

get_volume_result="$(wpctl get-volume @DEFAULT_AUDIO_SINK@)"

current_volume="$(echo $get_volume_result | grep -oP '(?<=Volume: ).*')"

percent=$(printf "%0.f" "$(echo "$current_volume * 100" | bc)")

icon="󰕿"
if [ $percent -gt 80 ]
then
  icon="󱄠"
elif [ $percent -gt 50 ]
then
  icon="󰕾"
elif [ $percent -gt 20 ]
then
  icon="󰖀"
fi

bar=$($HOME/.config/hypr/scripts/get-volume-bar.sh 48)

arg=""
id=$(cat $HOME/.config/hypr/data/volume-notification-id.txt)

if [ "$id" != "" ]
then
  arg="--replace-id $id"
fi

id=$(notify-send "$icon Volume - $percent%" "\n$bar" $arg --expire-time=1000 --print-id)

echo $id > $HOME/.config/hypr/data/volume-notification-id.txt