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

function action_build()
{
    ui_debug "BUILD"
    build_menu
}

function action_logger()
{
    ui_debug "LOG"
    log_main_menu
}

function action_flash()
{
    ui_debug "FLASH"
    if [ -z "${WM_DIR_IMAGES}" ]; then
        ui_errorbox "WM_DIR_IMAGES not defined"
        exit 1
    fi

    jlink_flash_menu $WM_DIR_IMAGES
}

function action_erase()
{
    ui_debug "ERASE"
    jlink_erase_menu
}

# $1 :  input number of action
function run_action()
{

option=$1

    if [ $option -eq "1" ]; then
        action_build
    elif [ $option -eq "2" ]; then
        action_logger
    elif [ $option -eq "3" ]; then
        action_flash
    elif [ $option -eq "4" ]; then
        action_erase
    else
        ui_errorbox "invalid action"
        exit 1
    fi

}

# input: list of target apps as an array
function action_build_app()
{
   clean=" clean"

   make_cmd="make -f  makefile ${WM_INTERNAL_STACK_BINARIES} app_name="
   cmd1="foo"
   cmd2="bar"

   arr=("$@")

   olddir=$PWD

   cd $WM_DIR_SDK

   ui_debug "Building at $PWD"

   for i in "${arr[@]}";
      do
          target=${i//\"/}
          cmd1=$make_cmd$target$clean
          cmd2=$make_cmd$target

          echo $cmd2
          exec $cmd2

          docker run -it --rm \
            --user=$(id -u):$(id -g) \
            -w ${WM_DIR_SDK} \
            --net=none \
            -v ${WM_DIR_SDK}:${WM_DIR_SDK} \
            -v ${WM_DIR_STACK}:${WM_DIR_STACK} \
            ${WM_DOCKER_IMAGE} \
            bash -c "echo cmd:${cmd2}; exec ${cmd2}"
      done

   cd $olddir

}

