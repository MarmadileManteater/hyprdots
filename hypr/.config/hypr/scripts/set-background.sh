
file=$1

cp "$1" $HOME/.config/hypr/background

swww img $HOME/.config/hypr/background

most_common_color=$(magick $HOME/.config/hypr/background -colors 1 -unique-colors txt: | tail -n1 | grep -o '#\(.*\) ')

hex_color="0x$(echo $most_common_color | grep -o "[^#]*")"

foreground="#FFFFFF"
echo $(( $(( 0xFFFFFF - $hex_color )) -  0x8FFFFF ))

if [[ $(( $(( 0xFFFFFF - $hex_color )) -  0x8FFFFF ))  == -* ]]
then
  foreground="#000000"
fi

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_color /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_color /** /accent */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

sed -i "s@/\*\* accent-fg \*/.*/\*\* /accent-fg \*/@/** accent-fg */ $foreground /** /accent-fg */@g" ~/.config/rofi/themes/style-1-1-launcher.rasi&> /dev/null

