#/bin/bash

$HOME/.config/hypr/scripts/kill-tmux-sessions.sh ollama-web-ui --exclude; sleep 2s && hyprctl $@ dispatch exit