#!/usr/bin/env bash
# Wirepas Oy

function jlink_erase_menu
{

    tmp_jlink_file="${HOME}/.wmerase.jlink"


    if [[ -z "$1" ]]
    then 
        devices=$(device_get_ids "(ERASE)")
    else
        devices=$1
    fi

    if [[ ${#devices} == 0 ]]
    then
        err="No devices connected."
        ui_errorbox "$err"
        echo $err
        exit 1
    fi

    # Set device only if it is not already set via env
    if [[ ${#WM_JLINK_DEVICE} == 0 ]]
    then
        WM_JLINK_DEVICE=${WM_DEFAULT_JLINK_DEVICE}
    fi

    fw_file=
    cmd="gsub(\"DEVICE\", \"$WM_JLINK_DEVICE\");"
    awk "{$cmd; print}" $WM_UTS_ERASE_JLINK > ${tmp_jlink_file}

    for dev in $devices; do
        JLINK_OPT="-SelectEmuBySN "
        JLINK_OPT+=${dev//\"/}
        JLinkExe $JLINK_OPT -CommanderScript ${tmp_jlink_file}
    done

    rm ${tmp_jlink_file}

}
