#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $DIR/list_input.sh

IFS=$'
'
lines=($(adb devices -l | grep "device "))
unset IFS
devices=()
for i in "${lines[@]}"
do
	d=$(echo $i | awk '{ print $1 }')
	n=$(echo $i | awk '{ print $6 }' | cut -d ':' -f 2)
	devices+=("$d - $n")
done

if [ "${#devices[@]}" -eq "1" ]; then
	dev=$(echo ${devices[0]} | cut -d " " -f 1)
	echo "$dev" > /tmp/selected_device
else
	list_input "Select android device:" devices selected_device
	dev=$(echo $selected_device | cut -d " " -f 1)
	echo "$dev" > /tmp/selected_device
fi


