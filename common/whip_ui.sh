#!/usr/bin/env bash
# Wirepas Oy


if [[ "$BASH_SOURCE" == "$0" ]]
then
    echo "Please run wmutils.sh"
    exit
fi

function ui_debug
{
    if [[ ! -z ${WM_DEBUG} ]]
    then
        echo $1
    fi
}


function ui_errorbox
{
    whiptail --title "Error" --msgbox "$1" 8 40
}

function ui_main_menu
{
    option=$(whiptail --title "Wirepas Firmware Utilities" --menu "Choose your option" 15 60 4 \
    "1" "Build Applications" \
    "2" "RTT Logger" \
    "3" "Program Firmware" \
    "4" "Erase Firmware"  3>&1 1>&2 2>&3)
 
    echo ${option}

    exit $?
}


function ui_log_menu
{
    option=$(whiptail --title "Wirepas Firmware Utilities" --menu "Choose your option" 15 60 3 \
    "1" "Start Session" \
    "2" "Kill Session"  \
    "3" "List sessions"  3>&1 1>&2 2>&3)
  
    echo ${option}

    exit $?
}