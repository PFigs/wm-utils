#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */

#set -x

function usage() 
{
     echo "Usage: $0 [-c <flash|erase>|list>]" 1>&2; 
     exit 1
}


function flash_device()
{
    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        jlink_flash_menu "$1" "$2" 
    fi
}

function erase_device()
{
    if [ ! -z "$1" ]; then
        jlink_erase_menu "$1" 
    fi
}


function parse_args()
{
   
    if [ $# -eq "0" ]; then
        exit 0
    fi


 
    while getopts hc:d:f: option 
    do 
    case "${option}" 
    in 
    c) c=${OPTARG};; 
    d) d=${OPTARG};; 
    f) f=${OPTARG};;
    h) usage;;
    *) usage;;   
    esac 
    done 

    

    if [ ${c} == "flash" ]
    then
        flash_device $d $f
    elif [ ${c} == "erase" ]
    then
        erase_device $d
    elif [ ${c} == "list" ]
    then
        device_list_devices
    fi  

    exit 0

}

    if [[ "$BASH_SOURCE" == "$0" ]];then

    parse_args "$@"
    

    fi





