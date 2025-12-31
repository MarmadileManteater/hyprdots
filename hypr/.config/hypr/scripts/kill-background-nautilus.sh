#/bin/bash

# only kills background nautilus processes

NAUTILUS_RUNNING=0
NAUTILUS_OPEN=0

if [ "$(hyprctl clients -j | jq '.[] | select(.class == "org.gnome.Nautilus") | .class')" != "" ]
then
  NAUTILUS_OPEN=1
fi

PID=$(pidof nautilus)

if [ "$PID" != "" ]
then
  NAUTILUS_RUNNING=1
fi

if [[ "$NAUTILUS_OPEN" == "0" && "$NAUTILUS_RUNNING" == "1" ]]
then
  kill $PID
fi