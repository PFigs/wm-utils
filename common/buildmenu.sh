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


function get_sdk_projects()
{
    echo $(ls $DIR_SDK/source) 
}

function buildmenu()
{
    PROJECTS=$(get_sdk_projects)

    PRJ_IDS_ARR=($PROJECTS)
    PRJ_IDS_LEN=${#PRJ_IDS_ARR[@]}
    if (( ${#PROJECTS} == 0 )); then
        exit 1
    fi

    for id in $PROJECTS; do
        if ((${#first} == 0)); then
            cl_ids="$id $id 1"
            first=false
        else
            cl_ids="$cl_ids $id $id 0"
        fi
    done

    PROJECTS=$(whiptail --notags --title "Application Builder" --checklist "Choose projects $1" \
    15 30 $PRJ_IDS_LEN \
    $cl_ids \
    3>&1 1>&2 2>&3)

    stat=$?
    if (( $stat != 0 )); then
        exit 1
    fi

    TARGETS=${PROJECTS//\"/}

    build_app $PROJECTS

    #build_app $"${PROJECTS[@]}"

    exit 0
}

