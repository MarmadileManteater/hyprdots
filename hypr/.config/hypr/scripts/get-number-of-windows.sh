#/bin/bash

# gets the number of open windows in hyprland given the class of the window

class=$1

hyprctl clients -j | jq ".[] | select(.class == \"$class\") | .pid" | wc -l