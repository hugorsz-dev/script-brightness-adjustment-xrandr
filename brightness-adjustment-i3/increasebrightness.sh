#!/bin/bash

increase=0.1
current_brightness=`xrandr --verbose | grep Brightness | sed 's/[^0-9.]*//g' | head -n1`
result_brightness=`bc -l <<< $current_brightness+$increase`

active_monitors=`xrandr --listactivemonitors | grep -o '[A-Z][A-Z]*-[0-9][0-9]*' | awk '!seen[$0]++'`

echo "$active_monitors" | tr ' ' '\n' | while read item; do
  xrandr --output $item --brightness $result_brightness
  notify-send  " (+) Brightness: $result_brightness"
done