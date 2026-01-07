#/bin/bash

percentage=$(amixer get Master volume | grep "[[0-9]*%]" -o | head -1)

num=${percentage:1:-2}

$HOME/.config/hypr/scripts/get-progress-bar.sh $num 100 $@