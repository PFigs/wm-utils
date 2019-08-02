#!/usr/bin/env bash
# Copyright 2019 Wirepas Ltd licensed under Apache License, Version 2.0

function jlink_connect_device
{
    JLINKEXE='JLinkExe'

    devs=$(device_get_ids "JLink")

    if [[ ${#devs} == 0 ]]
    then
        echo No devices
        exit 1
    fi

    devs_arr=( $devs )

    $JLINKEXE -SelectEmuBySN ${devs_arr[0]} -if swd -device ${WM_DEFAULT_JLINK_DEVICE} -autoconnect 1 -speed 4000
}


if [[ "$BASH_SOURCE" == "$0" ]]
then
    jlink_connect_device
fi
