#!/bin/bash

value=$1
max=$2
width=$3

percent=0

if [ "$width" == "percentage" ]
then
  percent=$value
  width=$max
else
  if [ "$width" == "" ]
  then
    width=10
  fi

  percent=$(echo "scale=2; $value / $max" | bc)
fi

amount=$(echo "$percent * $width" | bc)

for i in $(seq 1 $width)
do
  filled=$(echo "$amount + 0.5 >= $i" | bc)
  if [ $i -eq 1 ]
  then
    if [ $filled -eq 1 ]
    then
      printf ""
    else
      printf ""
    fi
  elif [ $i -eq $width ]
  then
    if [ $filled -eq 1 ]
    then
      printf ""
    else
      printf ""
    fi
  else
    if [ $filled -eq 1 ]
    then
      printf ""
    else
      printf ""
    fi
  fi
done