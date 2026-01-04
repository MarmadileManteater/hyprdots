#/bin/bash

which_param=""

rgb_param=$(echo "$@" | grep "\--rgb=.*[\)|\) ]" -o | xargs)
hex_param=$(echo "$@" | grep "\--hex=[0-9A-F]* *" -o | xargs)

PRINT_WHICH_WAS_GIVEN=0

if [[ $(echo "$@" | grep "\--which") != "" ]];
then
  PRINT_WHICH_WAS_GIVEN=1
fi

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
  echo "No valid color parameters given"
  exit
fi

echo "$rgb_param"
echo "$hex_param"

if [ $PRINT_WHICH_WAS_GIVEN -eq 1 ]
then
  echo "$which_param"
fi