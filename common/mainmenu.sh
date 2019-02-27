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


function main_menu()
{
    option=$(ui_main_menu)

    exitstatus=$?
    if [[ $exitstatus = 0 ]]
    then
        echo ${option}
        exit 0
    else
        echo "0"
        exit 1
    fi
}
