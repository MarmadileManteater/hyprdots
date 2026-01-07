/home/emma/.config/hypr/scripts/run-in-tmux.sh waybar "$bar"&
function run_ironbar() {
  sleep 1s
  if [[ -f /tmp/ironbar_was_killed.txt ]]
  then
    /home/emma/.config/hypr/scripts/run-in-tmux.sh ironbar "ironbar"
    rm /tmp/ironbar_was_killed.txt
  fi
}
run_ironbar&
hyprctl dispatch dpms on