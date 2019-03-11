#!/usr/bin/env bash

#/* Copyright 2019 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */

if [[ "$BASH_SOURCE" == "$0" ]]
then
    echo "Please run wmutils.sh"
    exit
fi

function device_list_devices
{
    segger_id=1366:1015
    usb_ids=$(lsusb -v -d ${segger_id} | grep iSerial | awk '{print $3}')
    echo $usb_ids
}

function device_get_ids
{

    segger_id=1366:1015

    usb_ids=$(lsusb -v -d ${segger_id} | grep iSerial | awk '{print $3}')
    usb_ids_arr=($usb_ids)
    usb_ids_len=${#usb_ids_arr[@]}
    if (( ${#usb_ids} == 0 )); then
        exit 1
    fi

    for id in $usb_ids; do
        if ((${#first} == 0)); then
            cl_ids="$id $id 1"
            first=false
        else
            cl_ids="$cl_ids $id $id 0"
        fi
    done

    #todo: move to whip_ui.sh
    devices=$(whiptail --notags --title "Segger JLink USB" --checklist "Choose devices $1" \
        15 30 $usb_ids_len \
        $cl_ids \
        3>&1 1>&2 2>&3)

    stat=$?
    if (( $stat != 0 )); then
        exit 1
    fi

    echo ${devices//\"/}

    exit 0

}
