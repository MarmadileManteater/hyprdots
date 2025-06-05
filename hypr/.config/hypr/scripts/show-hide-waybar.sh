
if [ ! -f /tmp/last-waybar-show-hide.txt ]
then
  echo 0 >> /tmp/last-waybar-show-hide.txt
fi

current_timestamp=$(date +%s%3N)
last_timestamp=$(cat /tmp/last-waybar-show-hide.txt)

# waybar freezes if you send this signal too much
if [ $(echo "$current_timestamp - $last_timestamp" | bc) -gt 1500 ]
then
  pkill -SIGUSR1 waybar
  echo $current_timestamp &> /tmp/last-waybar-show-hide.txt
fi

