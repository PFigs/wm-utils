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

function ui_debug()
{
    echo $1
}



function ui_errorbox()
{
    whiptail --title "Error" --msgbox "$1" 8 40
}
