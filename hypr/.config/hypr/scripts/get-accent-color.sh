#/bin/bash

SHORT_HELP="gets accent color"
HELP_ARGS="parameters:\n --no-hash flag (optional) - removes hash from output"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

hex=$(cat $HOME/.config/hypr/accent.txt)

if [ "$(echo "$@" | grep '\--no-hash' -o)" != "" ]
then
  echo ${hex:1:6}
else
  echo $hex
fi