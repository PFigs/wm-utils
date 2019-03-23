#!/usr/bin/env bash
# Wirepas Oy

function main_menu
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
