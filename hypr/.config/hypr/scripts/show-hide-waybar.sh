
if [ "$(tmux list-sessions | grep 'waybar' -o)" != "" ];
then
  tmux kill-session -twaybar
else
 $HOME/.config/hypr/scripts/run-in-tmux.sh waybar "$bar"&
fi


# if [ ! -f /tmp/last-waybar-show-hide.txt ]
#then
#  echo 0 >> /tmp/last-waybar-show-hide.txt
#fi

#current_timestamp=$(date +%s%3N)
#last_timestamp=$(cat /tmp/last-waybar-show-hide.txt)

# waybar freezes if you send this signal too much
#if [ $(echo "$current_timestamp - $last_timestamp" | bc) -gt 1500 ]
#then
#  pkill -SIGUSR1 waybar
#  echo $current_timestamp &> /tmp/last-waybar-show-hide.txt
#fi

