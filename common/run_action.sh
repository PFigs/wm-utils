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


#find free tcp port
function find_free_port()
{
    lower_port=19000 
    upper_port=20000
    
    while :; do
        for (( port = lower_port ; port <= upper_port ; port++ )); do
            nc -l -p "$port" 2>/dev/null && break 2
        done
    done

    echo $port
}


function build()
{
    echo "BUILD"
    buildmenu
}

function log()
{
    echo "LOG"
    log_menu
}

function flash()
{
    echo "FLASH"
    flash_menu $DIR_IMAGES
}

function erase()
{
    echo "ERASE"
    erase_menu
}

# $1 :  input number of action
function run_action() {

OPTION=$1

if [ $OPTION -eq "1" ]; then
    build
elif [ $OPTION -eq "2" ]; then
    log
elif [ $OPTION -eq "3" ]; then
    flash
elif [ $OPTION -eq "4" ]; then
    erase
else
    echo "invalid"
    exit 1
fi

}

# input: list of target apps as an array 
function build_app()
{
   CLEAN=" clean"

   MAKE_CMD="make -f makefile app_name="
   CMD1="foo" 
   CMD2="bar" 
 
   arr=("$@")
   
   olddir=$PWD
   cd $DIR_SDK
   echo "Building at $PWD"

   for i in "${arr[@]}";
      do
          TARGET=${i//\"/}
          CMD1=$MAKE_CMD$TARGET$CLEAN 
          CMD2=$MAKE_CMD$TARGET 
          #echo $CMD1
          #exec $CMD1

          echo $CMD2
          exec $CMD2  
         
      done

   cd $olddir   

}