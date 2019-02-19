#!/bin/bash

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


function erase_menu(){

EFR=EFR32MG12P332F1024GL125

DEVICES=$(get_device_ids "(ERASE)")
if ((${#DEVICES} == 0)); then
    ERR="No devices connected."
    ui_errorbox "$ERR"
    echo $ERR
    exit 1
fi

# Set device only if it is not already set via env
if ((${#JLINK_DEVICE} == 0)); then
    JLINK_DEVICE=$EFR
fi
fw_file=
cmd="gsub(\"DEVICE\", \"$JLINK_DEVICE\");"
awk "{$cmd; print}" $ERASE_JLINK > /tmp/erase.jlink

for DEV in $DEVICES; do
    JLINK_OPT="-SelectEmuBySN "
    JLINK_OPT+=${DEV//\"/}
    JLinkExe $JLINK_OPT -CommanderScript /tmp/erase.jlink
done

rm /tmp/erase.jlink

}