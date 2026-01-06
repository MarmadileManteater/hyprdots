#/bin/bash

# converts a hex color to a rgb color
# supports transparency

hex_param="$1"

if [ "${hex_param:0:1}" == "#" ]
then
  hex_param="${hex_param:1}"
fi

end="$(echo "(${#hex_param} / 2) - 1" | bc)"

rgb_color="rgb("

if [ $end -eq 3 ]
then
  rgb_color="rgba("
fi

for i in $(seq 0 $end)
do
  k=$(echo "$i * 2" | bc)
  this_param="${hex_param:$k:2}"
  if [ $end -eq 3 ]
  then
    if [ $i -eq $end ]
    then
      this_param=$(echo "scale=2;$(echo "ibase=16; ${hex_param:$k:2}" | bc).0 / 255" | bc)
      rgb_color="$rgb_color$this_param"
    fi
  fi
  if [ "$(echo $this_param | grep -o '\.')" == "" ]
  then
    rgb_color="$rgb_color$(echo "ibase=16; $this_param" | bc)"
  fi
  if [ $i != $end ]
  then
    rgb_color="$rgb_color, "
  else
    rgb_color="$rgb_color)"
  fi
done

echo $rgb_color