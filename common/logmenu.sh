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

#tmp_jlink_file="~/.wmerase.jlink"
#eval tmp_jlink_file=${tmp_jlink_file}

devices=$(get_device_ids "(RTT LOGGER)")

if ((${#devices} == 0)); then
    err="No devices connected."
    ui_errorbox "$err"
    echo $err
    exit 1
fi


echo "RTT PORT:$(find_free_port)"
exit 1

# Set device only if it is not already set via env
if ((${#JLINK_DEVICE} == 0)); then
    JLINK_DEVICE=${EFR}
fi
fw_file=
cmd="gsub(\"DEVICE\", \"$JLINK_DEVICE\");"
awk "{$cmd; print}" $ERASE_JLINK > ${tmp_jlink_file}

for dev in $devices; do
    JLINK_OPT="-SelectEmuBySN "
    JLINK_OPT+=${dev//\"/}
    JLinkExe $JLINK_OPT -CommanderScript ${tmp_jlink_file}
done

#rm ${tmp_jlink_file}

}