#/bin/bash

SHORT_HELP="sets accent color"
HELP_ARGS="parameters: (only needs 1 color parameter)\n - --hex= - color in hex format\n - --rgb= - color in RGB format\n - --nautilus flag (optional) - restarts nautilus if exactly one instance instance is open"

help_result=$($HOME/.config/hypr/scripts/is_help.sh "$SHORT_HELP" "$HELP_ARGS" $@)

if [ "$help_result" != "" ]
then
  echo "$help_result"
  exit
fi

CALLING_FROM_NAUTILUS=0

if [[ $(echo "$@" | grep "\--nautilus") != "" ]];
then
  CALLING_FROM_NAUTILUS=1
fi

# allow rgb or hex input
IFS=$'\n'
colors=($($HOME/.config/hypr/scripts/normalize-color-input.sh $@ --which))

if [ ${colors[0]:0:1} != "r" ]
then
  for output in "${colors[@]}"
  do
    echo "$output"
  done
  exit
fi

rgb_param=${colors[0]}
hex_param=${colors[1]}
which_param=${colors[2]}

# get the hex color as a hex number
hex_color="0x$(echo $hex_param | grep -o "[^#]*")"

if [ "${hex_param:0:1}" != "#" ]
then
  hex_param="#$hex_param"
fi

foreground="#FFFFFF"
accent_fg="white"
light_accent="lighter( lighter( lighter( var(--accent) ) ) )"

alt1=$($HOME/.config/hypr/scripts/modulate-color.sh --hex=${hex_param:1} --brightness=50)

alt2=$($HOME/.config/hypr/scripts/modulate-color.sh --hex=${hex_param:1} --brightness=100)

fastfetch=$alt2

alt_fg="#000000"

success="$hex_param"
error="$($HOME/.config/hypr/scripts/modulate-color.sh --hex=${hex_param:1} --invert)"

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0x8FFFFF ))  == -* ]]
then
  fastfetch=$hex_param
  foreground="#000000"
  alt1=$($HOME/.config/hypr/scripts/modulate-color.sh --hex=${hex_param:1} --brightness=-50)
  alt2=$($HOME/.config/hypr/scripts/modulate-color.sh --hex=${hex_param:1} --brightness=-100)
  alt_fg="#FFFFFF"
fi

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0xAFFFFF ))  == -* ]]
then
  accent_fg="black"
  light_accent="lighter( var(--accent) )"
fi


sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/wofi/style.css&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/wofi/style.css&> /dev/null

sed -i "s@\-\-accent: .*;@--accent: $rgb_param;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null
sed -i "s@\-\-accent-fg: .*;@--accent-fg: $accent_fg;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null
sed -i "s@\-\-light-accent: .*;@--light-accent: $light_accent;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null

sed -i "s@\"color\": \".*\"@\"color\": \"$fastfetch\"@g" ~/.config/fastfetch/config.jsonc &> /dev/null

sed -i "s@red = \".*\"#primary@red = \"$hex_param\"#primary@g" ~/.config/starship.toml

sed -i "s@redfg = \".*\"#primaryfg@redfg = \"$foreground\"#primaryfg@g" ~/.config/starship.toml

sed -i "s@green = \".*\"#secondary@green = \"$alt1\"#secondary@g" ~/.config/starship.toml

sed -i "s@greenfg = \".*\"#secondaryfg@greenfg = \"$alt_fg\"#secondaryfg@g" ~/.config/starship.toml

sed -i "s@blue = \".*\"#tertiary@blue = \"$alt2\"#tertiary@g" ~/.config/starship.toml

sed -i "s@bluefg = \".*\"#tertiaryfg@bluefg = \"$alt_fg\"#tertiaryfg@g" ~/.config/starship.toml

sed -i "s@success = \".*\"#success@success = \"$success\"#success@g" ~/.config/starship.toml

sed -i "s@error = \".*\"#error@error = \"$error\"#error@g" ~/.config/starship.toml

kill $(pidof gnome-calendar) &> /dev/null
kill $(pidof gnome-clocks) &> /dev/null

# kill nautilus if there a no windows
$HOME/.config/hypr/scripts/kill-background-nautilus.sh

# restart nautilus if the call is coming from inside the house
if [ "$CALLING_FROM_NAUTILUS" == "1" ];
then
  number_of_windows=$($HOME/.config/hypr/scripts/get-number-of-windows.sh org.gnome.Nautilus)

  # don't restart nautilus if there is more than 1 window open
  # only 1 window will be reopened, so if I call 
  # this with more than 1 window open accidentally,
  # I would rather not lose my place.
  if [[ $number_of_windows -lt 2 ]]
  then
    nautilus_id=$(pidof nautilus)
    
    if [ "$nautilus_id" != "" ];
    then
    dirname="$(pwd)"
    kill $nautilus_id
    nautilus "$dirname"&
    fi
  fi
fi

vocal_param=""

if [ "$which_param" == "hex" ]
then
  vocal_param="$hex_param"
fi

if [ "$which_param" == "rgb" ]
then
  vocal_param="$rgb_param"
fi

echo "Set accent to $(echo " $vocal_param" | $HOME/.config/hypr/scripts/print-as-color.sh --hex=${hex_param:1:6})"

echo $hex_param > $HOME/.config/hypr/accent.txt
echo $fastfetch > $HOME/.config/hypr/fg-accent.txt