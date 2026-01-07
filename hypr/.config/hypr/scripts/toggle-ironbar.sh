#!/bin/bash

for i in $(seq 1 4)
do
  ironbar bar ironbar-$i toggle-visible
done