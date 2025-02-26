#!/bin/bash
# /* ---- 💫 pulled from https://github.com/JaKooLit/Hyprland-Dots/blob/main/config/hypr/scripts/WaybarCava.sh 💫 and modified to work better on multimonitor setups ---- */  ##
# original work licensed under GPLv3.0 : https://github.com/JaKooLit/Hyprland-Dots/blob/main/LICENSE.md

     
bar="▁▂▃▄▅▆▇█"
dict="s/;//g"

# Calculate the length of the bar outside the loop
bar_length=${#bar}

# Create dictionary to replace char with bar
for ((i = 0; i < bar_length; i++)); do
    dict+=";s/$i/${bar:$i:1}/g"
done

# Create cava config
config_file="/tmp/bar_cava_config"
cat >"$config_file" <<EOF
[general]
bars = 10

[input]
method = pulse
source = auto

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 7
EOF

# Kill cava if it's already running
pkill -f "cava -p $config_file"

cava -p "$config_file" > /tmp/cava.log&

# Read stdout from the file and perform substitution in a single sed command
tail -f /tmp/cava.log | sed -u "$dict;s/▁▁▁▁▁▁▁▁▁▁//g"
