#/bin/bash

# wipe tmux env
kill $(pidof tmux)

# wallpaper
$HOME/.config/hypr/scripts/run-in-tmux.sh swww "swww-daemon"&
if [ "$bar" != "hyprpanel" ]
then
  # notifications
  $HOME/.config/hypr/scripts/run-in-tmux.sh swaync "swaync"&
fi
# polkit
$HOME/.config/hypr/scripts/run-in-tmux.sh xfce-polkit "/usr/libexec/xfce-polkit"&
# taskbar
$HOME/.config/hypr/scripts/run-in-tmux.sh waybar "sleep 4 && $bar"&
# dock
$HOME/.config/hypr/scripts/run-in-tmux.sh ironbar "sleep 8 && ironbar"&
# idle
$HOME/.config/hypr/scripts/run-in-tmux.sh hypridle "sleep 4 && hypridle"&
# launch pia
$HOME/.config/hypr/scripts/run-in-tmux.sh privateinternetaccess "sleep 4 && /opt/piavpn/bin/pia-client --quiet"&

# launch discord, element, tutamail
$HOME/.config/hypr/scripts/run-in-tmux.sh discord "flatpak run com.discordapp.Discord" && sleep 4 && $HOME/.config/hypr/scripts/run-in-tmux.sh element "flatpak run im.riot.Riot" && sleep 4 && hyprctl dispatch workspace 3 && hyprctl dispatch workspace 13 && $HOME/.config/hypr/scripts/run-in-tmux.sh tutamail "firefox --new-window https://app.tuta.com/" && sleep 3s && hyprctl dispatch workspace 3

# launch openrgb
$HOME/.config/hypr/scripts/run-in-tmux.sh openrgb "sleep 8 && openrgb --startminimized"

# these two should be system level, but they never seem to launch consistently with systemd
# launch ollama-web-ui
$HOME/.config/hypr/scripts/run-in-tmux.sh ollama-web-ui 'cd /mnt/personal/programs/ollama-web-ui/ollama-webui/backend && sh start.sh'
# run mc server
# $HOME/.config/hypr/scripts/run-in-tmux.sh minecraft 'cd /mnt/personal/programs/linux/minecraft-servers/forge-16.5/ && ./run-server.sh'
