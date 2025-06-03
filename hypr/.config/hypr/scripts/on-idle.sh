tmux kill-session -twaybar
tmux kill-session -tironbar && touch /tmp/ironbar_was_killed.txt
hyprctl dispatch dpms off