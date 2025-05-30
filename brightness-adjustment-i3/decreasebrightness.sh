#!/bin/bash

decrease=0.1
current_brightness=`xrandr --verbose | grep Brightness | sed 's/[^0-9.]*//g' | head -n1`
result_brightness=`bc -l <<< $current_brightness-$decrease`

active_monitors=`xrandr --listactivemonitors | grep ": +" |  awk '{print $NF}'`

echo "$active_monitors" | tr ' ' '\n' | while read item; do
  xrandr --output $item --brightness $result_brightness
  notify-send  " (-) Brightness: $result_brightness"
done
