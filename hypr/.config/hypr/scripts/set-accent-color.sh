#/bin/bash

CALLING_FROM_NAUTILUS=0

if [[ $(echo "$@" | grep "\--nautilus") != "" ]];
then
  CALLING_FROM_NAUTILUS=1
fi

which_param=""

rgb_param=$(echo "$@" | grep "\--rgb=.*[\)|\) ]" -o | xargs)
hex_param=$(echo "$@" | grep "\--hex=[0-9A-F]* *" -o | xargs)

if [ "$rgb_param" != "" ]
then
  rgb_param="${rgb_param:6:-1})"
  rgb_param="rgb$(echo $rgb_param | grep -o '([0-9]*, *[0-9]*, *[0-9]*'))"
fi

if [ "$hex_param" != "" ]
then
  hex_param="${hex_param:6:6}"
  if [ "${#hex_param}" -lt 6 ]
  then
    if [ "$rgb_param" == "" ]
    then
      echo "Hex not long enough"
    fi
    # invalid input
    hex_param=""
  fi
fi

if [ "$rgb_param" != "" ]
then
  which_param="rgb"
  hex_param=$(~/.config/hypr/scripts/rgb-to-hex.sh "$rgb_param")
elif [ "$hex_param" != "" ]
then
  which_param="hex"
  rgb_param=$(~/.config/hypr/scripts/hex-to-rgb.sh "$hex_param")
else
  echo "No valid parameters given"
  exit
fi

if [ "${hex_param:0:1}" != "#" ]
then
  hex_param="#$hex_param"
fi

# get the hex color as a hex number
hex_color="0x$(echo $hex_param | grep -o "[^#]*")"

waybar_bg="rgba(0, 0, 0, 0.25)"
foreground="#FFFFFF"
accent_fg="white"
light_accent="lighter( lighter( lighter( var(--accent) ) ) )"

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0x8FFFFF ))  == -* ]]
then
  foreground="#000000"

fi

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0xAFFFFF ))  == -* ]]
then
  waybar_bg="rgba(0, 0, 0, 0.5)"
  accent_fg="black"
  light_accent="lighter( var(--accent) )"
fi

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $hex_param /** /accent */@g" ~/.config/wofi/style.css&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/wofi/style.css&> /dev/null


sed -i "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" ~/.config/waybar/style.css &> /dev/null

cat ~/.config/ironbar/style.css | sed "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" | tee ~/.config/ironbar/style.css &> /dev/null

sed -i "s@\-\-accent: .*;@--accent: $rgb_param;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null
sed -i "s@\-\-accent-fg: .*;@--accent-fg: $accent_fg;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null
sed -i "s@\-\-light-accent: .*;@--light-accent: $light_accent;@g" ~/.config/gtk-4.0/gtk.css &> /dev/null

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
    dirname="$(dirname "$1")"
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

echo "Set accent to $vocal_param"