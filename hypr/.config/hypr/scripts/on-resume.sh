/home/emma/.config/hypr/scripts/run-in-tmux.sh waybar "waybar"&
function run_ironbar() {
  sleep 1s
  /home/emma/.config/hypr/scripts/run-in-tmux.sh ironbar "ironbar"
}
run_ironbar&
hyprctl dispatch dpms on