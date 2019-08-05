#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ADB=$(which adb)


count=$($ADB devices | wc -l)

if [ "$1" == "devices" ]; then
	$ADB $@
	exit
elif [ "$1" == "select" ]; then
	$DIR/select_device.sh
	exit
fi



if [ $count -eq 2 ]; then
	echo "error: no devices/emulators found :("
	exit 1
elif [ $count -eq 3 ]; then
	$ADB $@
else
	if [ -f /tmp/selected_device ]; then
		device=$(cat /tmp/selected_device)
		$ADB devices | grep $device &> /dev/null
		ok=$?
		if [ $ok -ne 0 ]; then
			$DIR/select_device.sh
			device=$(cat /tmp/selected_device)
		fi
		$ADB -s $device $@
	else
		$DIR/select_device.sh
		device=$(cat /tmp/selected_device)
		$ADB -s $device $@
	fi
fi


