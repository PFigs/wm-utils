#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */

if [[ "$BASH_SOURCE" == "$0" ]]
then
    echo "Please run wmutils.sh"
    exit
fi



function get_device_ids(){

    SEGGER_ID=1366:1015

    USB_IDS=$(lsusb -v -d $SEGGER_ID | grep iSerial | awk '{print $3}')
    USB_IDS_ARR=($USB_IDS)
    USB_IDS_LEN=${#USB_IDS_ARR[@]}
    if (( ${#USB_IDS} == 0 )); then
        exit 1
    fi

    for id in $USB_IDS; do
        if ((${#first} == 0)); then
            cl_ids="$id $id 1"
            first=false
        else
            cl_ids="$cl_ids $id $id 0"
        fi
    done


DEVICES=$(whiptail --notags --title "Segger JLink USB" --checklist "Choose devices $1" \
    15 30 $USB_IDS_LEN \
    $cl_ids \
    3>&1 1>&2 2>&3)
stat=$?
if (( $stat != 0 )); then
    exit 1
fi

echo ${DEVICES//\"/}

}