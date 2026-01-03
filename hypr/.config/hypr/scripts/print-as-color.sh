#/bin/bash

# allow rgb or hex input
IFS=$'\n'
colors=($($HOME/.config/hypr/scripts/normalize-color-input.sh $@))

if [ ${colors[0]:0:1} != "r" ]
then
  for output in "${colors[@]}"
  do
    echo "$output"
  done
  exit
fi

rgb_param=${colors[0]}

rgb=($(echo $rgb_param | grep "[0-9]*" -o))

read output
printf "\033[38;2;${rgb[0]};${rgb[1]};${rgb[2]}m%s\033[0m\n" $output

