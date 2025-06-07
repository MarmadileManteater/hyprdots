
file=$1

cp "$1" $HOME/.config/hypr/background

swww img $HOME/.config/hypr/background

most_common_color=$(magick $HOME/.config/hypr/background -colors 1 -unique-colors txt: | tail -n1)
most_common_hex=$(echo $most_common_color | grep -o '#\(.*\) ')
most_common_rgb="rgb$(echo $most_common_color | grep -o '(\(.*\)) '  | tr -d '[:space:]')"
hex_color="0x$(echo $most_common_hex | grep -o "[^#]*")"

waybar_bg="rgba(0, 0, 0, 0.25)"
foreground="#FFFFFF"
accent_fg="white"

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0x8FFFFF ))  == -* ]]
then
  foreground="#000000"

fi

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0xAFFFFF ))  == -* ]]
then
  waybar_bg="rgba(0, 0, 0, 0.5)"
  accent_fg="black"
fi

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_hex /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_hex /** /accent */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" ~/.config/waybar/style.css &> /dev/null

cat ~/.config/ironbar/style.css | sed "s@/\*\* bg \*/.*/\*\* /bg \*/@/** bg */ $waybar_bg /** /bg */@g" | tee ~/.config/ironbar/style.css &> /dev/null

sed -i "s@\-\-accent: .*;@--accent: $most_common_rgb;@g" ~/.config/gtk-4.0/gtk.css
sed -i "s@\-\-accent-fg: .*;@--accent-fg: $accent_fg;@g" ~/.config/gtk-4.0/gtk.css