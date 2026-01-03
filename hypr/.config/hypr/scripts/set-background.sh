
CALLING_FROM_NAUTILUS=0

if [[ $(echo "$@" | grep "\--nautilus") != "" ]];
then
  CALLING_FROM_NAUTILUS=1
fi

file=$1

cp "$1" $HOME/.config/hypr/background

swww img $HOME/.config/hypr/background

most_common_color=$(magick $HOME/.config/hypr/background -colors 1 -unique-colors txt: | tail -n1)
most_common_hex=$(echo $most_common_color | grep -o '#\(.*\) ')
# remove alpha channel
if [[ "${#most_common_hex}" -eq 10 ]]
then
  most_common_hex="${most_common_hex:0:-3}"
fi
most_common_rgb="rgb$(echo $most_common_color | grep -o '([0-9]*,[0-9]*,[0-9]*'))"
hex_color="0x$(echo $most_common_hex | grep -o "[^#]*")"

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

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_hex /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_hex /** /accent */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_hex /** /accent */@g" ~/.config/wofi/style.css&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/wofi/style.css&> /dev/null


sed -i "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" ~/.config/waybar/style.css &> /dev/null

cat ~/.config/ironbar/style.css | sed "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" | tee ~/.config/ironbar/style.css &> /dev/null

sed -i "s@\-\-accent: .*;@--accent: $most_common_rgb;@g" ~/.config/gtk-4.0/gtk.css
sed -i "s@\-\-accent-fg: .*;@--accent-fg: $accent_fg;@g" ~/.config/gtk-4.0/gtk.css
sed -i "s@\-\-light-accent: .*;@--light-accent: $light_accent;@g" ~/.config/gtk-4.0/gtk.css

kill $(pidof gnome-calendar)
kill $(pidof gnome-clocks)

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

