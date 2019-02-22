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

function build()
{
    ui_debug "BUILD"
    buildmenu
}

function log()
{
    ui_debug "LOG"
    log_main
}

function flash()
{
    ui_debug "FLASH"
    if [ -z "${WM_DIR_IMAGES}" ]; then
        ui_errorbox "WM_DIR_IMAGES not defined"
        exit 1
    fi

    flash_menu $WM_DIR_IMAGES
}

function erase()
{
    ui_debug "ERASE"
    erase_menu
}

# $1 :  input number of action
function run_action()
{

option=$1

    if [ $option -eq "1" ]; then
        build
    elif [ $option -eq "2" ]; then
        log
    elif [ $option -eq "3" ]; then
        flash
    elif [ $option -eq "4" ]; then
        erase
    else
        ui_errorbox "invalid action"
        exit 1
    fi

}

# input: list of target apps as an array 
function build_app()
{
   clean=" clean"

   make_cmd="make -f makefile app_name="
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
          #echo $cmd1
          #exec $cmd1

          echo $cmd2
          exec $cmd2  
         
      done

   cd $olddir   

}

