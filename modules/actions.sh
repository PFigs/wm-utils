#!/usr/bin/env bash
# Copyright 2019 Wirepas Ltd licensed under Apache License, Version 2.0

function action_build
{
    ui_debug "BUILD"
    build_menu
}

function action_logger
{
    ui_debug "LOG"
    log_main_menu
}

function action_flash
{
    ui_debug "FLASH"
    if [[ -z "${WM_UTS_SDK_IMAGES_PATH}" ]]
    then
        ui_errorbox "WM_UTS_SDK_IMAGES_PATH not defined"
        exit 1
    fi

    jlink_flash_menu
}

function action_erase
{
    ui_debug "ERASE"
    jlink_erase_menu
}

# $1 :  input number of action
function run_action
{

    option=$1

    if [[ $option -eq "1" ]]
    then
        action_build
    elif [[ $option -eq "2" ]]
    then
        action_logger
    elif [[ $option -eq "3" ]]
    then
        action_flash
    elif [[ $option -eq "4" ]]
    then
        action_erase
    else
        ui_errorbox "invalid action"
        exit 1
    fi

}

# input: list of target apps as an array
function action_build_app
{
    clean=" clean"

    make_cmd="make -f makefile "
    board_selection="target_board=${WM_UTS_TARGET_BOARD} "
    app_selection="app_name="

    if [[ -z ${WM_UTS_TARGET_BOARD} ]]
    then
        board_selection=""
    fi

    make_cmd=$make_cmd${board_selection}${app_selection}

    cmd1="foo"
    cmd2="bar"

    arr=("$@")

    olddir=${PWD}

    cd ${WM_UTS_SDK_PATH}

    ui_debug "Building at $PWD"

    for i in "${arr[@]}";
      do
          target=${i//\"/}
          cmd1=$make_cmd$target$clean
          cmd2=$make_cmd$target

          echo $cmd2
          exec $cmd2

      done

    cd $olddir

}
