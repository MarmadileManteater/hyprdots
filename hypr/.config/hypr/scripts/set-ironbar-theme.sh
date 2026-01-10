#!/bin/bash

SHORT_HELP="sets ironbar theme"
HELP_ARGS="parameters:\n - theme - theme name"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

theme="$1"

if [ "$theme" == "" ]
then
  theme="default"
fi

if [ ! -d $HOME/.config/ironbar/themes/$theme ]
then
  echo "Theme \"$theme\" not found"
  exit
fi

unlink $HOME/.config/ironbar/config.corn
unlink $HOME/.config/ironbar/style.css
ln -s $HOME/.config/ironbar/themes/$theme/config.corn $HOME/.config/ironbar/config.corn
ln -s $HOME/.config/ironbar/themes/$theme/style.css $HOME/.config/ironbar/style.css

# restart ironbar to see the change
tmux kill-session -tironbar
$HOME/.config/hypr/scripts/run-in-tmux.sh "ironbar" "ironbar"