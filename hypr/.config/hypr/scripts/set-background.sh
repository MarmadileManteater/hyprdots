
file=$1

cp "$1" $HOME/.config/hypr/background

swww img $HOME/.config/hypr/background

most_common_color=$(magick $HOME/.config/hypr/background -colors 1 -unique-colors txt: | tail -n1 | grep -o '#\(.*\) ')

sed -i "s@/\*\* accent \*/.*/\*\* /accent \*/@/** accent */ $most_common_color /** /accent */@g" ~/.config/waybar/modules/wlogout/power-menu.css &> /dev/null