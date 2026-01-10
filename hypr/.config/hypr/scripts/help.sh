#!/bin/bash

function print_accent () {
  echo $@ | $HOME/.config/hypr/scripts/print-as-color.sh --hex=$($HOME/.config/hypr/scripts/get-accent-color.sh --no-hash --fg)
}

echo "Commands:"

echo "  $(print_accent "set-bg") - $($HOME/.config/hypr/scripts/set-background.sh --help-short)"
echo "  $(print_accent "set-accent") - $($HOME/.config/hypr/scripts/set-accent-color.sh --help-short)"
echo "  $(print_accent "get-accent") - $($HOME/.config/hypr/scripts/get-accent-color.sh --help-short)"
echo "  $(print_accent "accent-options") - $($HOME/.config/hypr/scripts/change-accent-from-wallpaper.sh --help-short)"
echo "  $(print_accent "printc") - $($HOME/.config/hypr/scripts/print-as-color.sh --help-short)"
echo "  $(print_accent "logout") - $($HOME/.config/hypr/scripts/logout.sh --help-short)"
echo "  $(print_accent "fix-iron-bar-shortcuts") - $($HOME/.config/hypr/scripts/fix-ironbar-shortcuts.sh --help-short)"
echo "  $(print_accent "set-ironbar-theme") - $($HOME/.config/hypr/scripts/set-ironbar-theme.sh --help-short)"