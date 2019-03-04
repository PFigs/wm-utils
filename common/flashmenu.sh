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

function check_file()
{
    file="$1" 

    if [[ -f $file ]]
    then
        ui_debug "Firmware File $FILE exists."
    else
        echo "Firmware File $file does not exist."
        #fallback, kill with PID
        exit $?
    fi
}


function jlink_flash_menu(){

    tmp_jlink_file="${HOME}/.wmflash.jlink"

    if [[ -z "$2" ]]
    then 
        fw_dir=${WM_DIR_IMAGES}

        old_dir=$PWD

        cd $fw_dir

        images=$(find . -name '*.hex' | cut -c2- | grep final)

        cd ${old_dir}

        if [[ -z "$images" ]]
        then
            err="No images found in $fw_dir!"
            ui_errorbox "$err"
            echo $err
            exit 1
        fi

        images_arr=($images)
        images_len=${#images_arr[@]}

        if [[ ${#images_len} == 0 ]]
        then
            err="No images found!"
            ui_errorbox "$err"
            echo $err
            exit 1
        fi

        for img in $images; do
            if [[ $img == "bl_wm_rtos_app.hex" ]]
            then
                rl_imgs="$rl_imgs $img $img 1"
            else
                rl_imgs="$rl_imgs $img $img 0"
            fi
        done

        #TODO: move to whip_ui.sh
        image=$(whiptail --notags --title "Flash" --radiolist "Select image" \
            15 80 $images_len \
            $rl_imgs \
            3>&1 1>&2 2>&3)
        stat=$?

        if [[ $stat != 0 ]]
        then
            err="Cancelled"
            ui_errorbox "$err"
            echo $err
            exit 1
        fi

        if [[ -z "$image" ]]
        then

            err="No image selected!"
            ui_errorbox "$err"
            echo $err
            exit 1
        fi

        devices=$(device_get_ids "(FLASH)")
        
        if [[ ${#devices} == 0 ]]
        then

            err="No devices connected."
            ui_errorbox "$err"
            echo $err
            exit 1
        fi

        # Set device only if it is not already set via env
        if [[ ${#JLINK_DEVICE} == 0 ]]
        then
            JLINK_DEVICE=${WM_DEFAULT_JLINK_DEVICE}
        fi

        fw_file=$fw_dir/${image}

    else
        devices=$1
        fw_file=$2
 
        # Set device only if it is not already set via env
        if [[ ${#JLINK_DEVICE} == 0 ]]
        then
            JLINK_DEVICE=${WM_DEFAULT_JLINK_DEVICE}
        fi        
    fi

    check_file ${fw_file}

    ui_debug "selected:"${fw_file}

    cmd="gsub(\"DEVICE\", \"$JLINK_DEVICE\"); gsub(\"FIRMWARE\", \"$fw_file\");"

    awk "{${cmd}; print}" $FLASH_JLINK > ${tmp_jlink_file}

    for dev in ${devices}; do
        JLINK_OPT="-SelectEmuBySN "
        JLINK_OPT+=${dev//\"/}
        JLinkExe ${JLINK_OPT} -CommanderScript ${tmp_jlink_file}
    done

    rm ${tmp_jlink_file}

exit 0

}