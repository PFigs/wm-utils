#!/usr/bin/env bash


if [[ "$BASH_SOURCE" == "$0" ]]
then
    . "devmenu.sh"
fi


function jlink_connect_device()
{
    JLINKEXE='JLinkExe'
    if (( ${#EFR} == 0 )); then
        EFR=EFR32MG12P332F1024GL125
    fi

    devs=$(device_get_ids "JLink")
    if (( ${#devs} == 0 )); then
        echo No devices
        exit 1
    fi
    devs_arr=( $devs )

    $JLINKEXE -SelectEmuBySN ${devs_arr[0]} -if swd -device $EFR -autoconnect 1 -speed 4000
}




if [[ "$BASH_SOURCE" == "$0" ]]
then
    jlink_connect_device
fi

