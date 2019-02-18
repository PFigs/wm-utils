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



function flash_menu(){

EFR=EFR32MG12P332F1024GL125
FW_DIR=$1
#if (( ${#1} == 0 )); then

    cd $FW_DIR

    IMAGES=$(ls *.hex)
    
    cd $DIR
    
    IMAGES_ARR=($IMAGES)
    IMAGES_LEN=${#IMAGES_ARR[@]}
    if (( ${#IMAGES_LEN} == 0 )); then
        echo "No images found!"
        exit 1
    fi

    for img in $IMAGES; do
        if [[ $img == "bl_wm_rtos_app.hex" ]]; then
            rl_imgs="$rl_imgs $img $img 1"
        else
            rl_imgs="$rl_imgs $img $img 0"
        fi
    done

    IMAGE=$(whiptail --notags --title "Flash" --radiolist "Select image" \
        15 50 $IMAGES_LEN \
        $rl_imgs \
        3>&1 1>&2 2>&3)
    stat=$?
    if (( $stat != 0 )); then
        echo "Cancelled!"
        exit 1
    fi
#else
#    IMAGE=$1
#fi

DEVICES=$(get_device_ids "(FLASH)")
if ((${#DEVICES} == 0)); then
    echo "No devices"
    exit 1
fi

# Set device only if it is not already set via env
if ((${#JLINK_DEVICE} == 0)); then
    JLINK_DEVICE=$EFR
fi
fw_file=$FW_DIR/$IMAGE
cmd="gsub(\"DEVICE\", \"$JLINK_DEVICE\"); gsub(\"FIRMWARE\", \"$fw_file\");"
awk "{$cmd; print}" $FLASH_JLINK > /tmp/flash.jlink

for DEV in $DEVICES; do
    JLINK_OPT="-SelectEmuBySN "
    JLINK_OPT+=${DEV//\"/}
    JLinkExe $JLINK_OPT -CommanderScript /tmp/flash.jlink
done

rm /tmp/flash.jlink

}