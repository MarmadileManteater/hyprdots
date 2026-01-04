#/bin/bash

SHORT_HELP="cleanly logs out of hyprland session"
HELP_ARGS="parameters:\n - --instance (optional) - the hyprland instance to logout (DEFAULT current session)"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

$HOME/.config/hypr/scripts/kill-tmux-sessions.sh ollama-web-ui --exclude; sleep 2s && hyprctl $@ dispatch exit