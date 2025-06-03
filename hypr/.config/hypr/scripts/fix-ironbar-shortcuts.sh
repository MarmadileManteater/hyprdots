#!/bin/bash

for arg in "$@"
do
  if [[ "$(cat /usr/share/applications/$arg.desktop | grep 'run-in-tmux.sh')" == "" ]]
  then
    sed -i "s@^Exec=\(.*\)@Exec=$(dirname ${BASH_SOURCE[0]})/run-in-tmux.sh $(echo $arg | sed 's@\.@_@g') \"\1\"@g" /usr/share/applications/$arg.desktop
  else
    echo "Skipping $arg"
  fi
done