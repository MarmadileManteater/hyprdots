#/bin/bash

# converts a rgb color to a hex color
# supports rgba

rgb_param="$1"

if [ "$rgb_param" != "" ]
then
  rgb_array=$(echo "$rgb_param" | grep "\([0-9]*\)" -o)
  hex_color="#"
  for number in $rgb_array
  do
    hex_number="$(printf "%X" $number)"
    if [ "${#hex_number}" -eq 1 ]
    then
      hex_number="0$hex_number"
    fi
    hex_color="$hex_color$(printf "%s" $hex_number)"
  done
  echo $hex_color
fi
