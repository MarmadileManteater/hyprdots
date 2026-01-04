#/bin/bash

hex=$(cat $HOME/.config/hypr/accent.txt)

if [ "$(echo "$@" | grep '\--no-hash' -o)" != "" ]
then
  echo ${hex:1:6}
else
  echo $hex
fi