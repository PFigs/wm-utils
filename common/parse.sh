#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */

#set -x

function usage() 
{
     echo "Usage: $0 COMMAND <OPTIONS>" 1>&2; 
     echo "    -c <options>                        : flash commands " 1>&2;
     echo "       erase -d [nodeid]                : erase flash"  1>&2; 
     echo "       flash -d [nodeid] -f [filename]  : flash firmware image"  1>&2; 
     echo "    " 1>&2;
     echo "    -l list                             : list connected devices"  1>&2; 
     echo "    " 1>&2; 
     echo "    -s                                  : show settings" 1>&2; 



}

function show_settings()
{
    echo "Settings"

    echo "Device family: ${WM_DEFAULT_JLINK_DEVICE}"
    echo "SDK projects directory: ${WM_DIR_SDK}"
    echo "Firmware images directory: ${WM_DIR_IMAGES}"
    echo "Connected Devices"
    device_list_devices

}



function flash_device()
{
    if [[ ! -z "$1" ]] && [[ ! -z "$2" ]]
    then
        jlink_flash_menu "$1" "$2"
    else
        #ui_errorbox "missing parameters"
        usage  
    fi
}

function erase_device()
{
    if [[ ! -z "$1" ]]
    then
        jlink_erase_menu "$1"
    else
        #ui_errorbox "device id missing"
        usage
    fi
}


function parse_args()
{
   
    if [[ $# -eq "0" ]]
    then
        exit 0
    fi


 
    while getopts hc:d:f:sl option 
    do 
    case "${option}" 
    in 
    c) c=${OPTARG};; 
    d) d=${OPTARG};; 
    f) f=${OPTARG};;
    s) show_settings;;
    l) device_list_devices;;
    h) usage;;
    *) usage;;   
    esac 
    done 

    

    if [[ ${c} == "flash" ]]
    then
        flash_device $d $f
    elif [[ ${c} == "erase" ]]
    then
        erase_device $d
    elif [[ ${c} == "list" ]]
    then
        device_list_devices
    fi  

    exit 0

}

    if [[ "$BASH_SOURCE" == "$0" ]];then

    parse_args "$@"

    fi





