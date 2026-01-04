#!/bin/bash

SHORT_HELP="adds tmux session prefix to ironbar shortcuts"
HELP_ARGS="parameters: names of desktop files to modify"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

for arg in "$@"
do
  if [[ "$(cat /usr/share/applications/$arg.desktop | grep 'run-in-tmux.sh')" == "" ]]
  then
    sudo sed -i "s@^Exec=\(.*\)@Exec=$(dirname ${BASH_SOURCE[0]})/run-in-tmux.sh $(echo $arg | sed 's@\.@_@g') \"\1\"@g" /usr/share/applications/$arg.desktop
  else
    echo "Skipping $arg"
  fi
done