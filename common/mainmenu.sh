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


function main_menu(){

OPTION=$(whiptail --title "Wirepas Firmware Utilities" --menu "Choose your option" 15 60 4 \
"1" "Build Applications" \
"2" "RTT Logger" \
"3" "Program Firmware" \
"4" "Erase Firmware"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ]; then
    echo $OPTION    
else
    echo "0"
fi

}
