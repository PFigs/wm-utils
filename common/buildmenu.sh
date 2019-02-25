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


function build_get_sdk_projects()
{
    projects=$(ls ${WM_DIR_SDK}/source) 

    if [ $? -ne 0 ]; then
        exit 1
    fi

    echo $projects
}

function build_menu()
{
    projects=$(build_get_sdk_projects)

    if [ -z "${projects}" ]; then 
        ui_errorbox "SDK path $WM_DIR_SDK not accessible"
        exit 1
    fi

    prj_ids_arr=($projects)
    prj_ids_len=${#prj_ids_arr[@]}
    if (( ${#projects} == 0 )); then
        exit 1
    fi

    for id in $projects; do
        if ((${#first} == 0)); then
            cl_ids="$id $id 1"
            first=false
        else
            cl_ids="$cl_ids $id $id 0"
        fi
    done

    #todo: move top whip_ui.sh
    projects=$(whiptail --notags --title "Application Builder" --checklist "Choose projects $1" \
    15 30 $prj_ids_len \
    $cl_ids \
    3>&1 1>&2 2>&3)


    stat=$?
    if (( $stat != 0 )); then
        exit 1
    fi

    targets=${projects//\"/}

    action_build_app ${projects}

    exit 0
}

