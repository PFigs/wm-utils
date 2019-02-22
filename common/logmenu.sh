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


function log_menu()
{
    devices=$(get_device_ids "(LOGGER)")

    if ((${#devices} == 0)); then
        err="No devices connected."
        ui_errorbox "$err"
        echo $err
        exit 1
    fi

    for dev in $devices; do
        port=$(find_free_port)
        rtt_start_session $dev $port
    done
}