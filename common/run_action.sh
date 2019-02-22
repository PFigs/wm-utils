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

    lowerport=19200
    upperport=19999

    while :
    do
        port=$(shuf -i $lowerport-$upperport -n 1)
        ss -lpn | grep -q ":$port " || break
    done
    echo $port
}

function build()
{
    ui_debug "BUILD"
    buildmenu
}

function log()
{
    ui_debug "LOG"
    log_menu
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

# $1 Segger ID
# $2 Telnet Port
function start_rtt_screen()
{
    rtt_session="$1_$2.sh"

    echo "rtt_session"

    mkdir -p ${WM_DIR_RTT_SESSIONS}

        # Set device only if it is not already set via env
    if ((${#JLINK_DEVICE} == 0)); then
        JLINK_DEVICE=${EFR}
    fi

    rtt_command="JLinkExe SelectEmuBySN $1 -device $JLINK_DEVICE -if SWD -speed auto -AutoConnect 1 -RTTTelnetPort $2"

    echo ${rtt_command}

    echo ${rtt_command} > "$WM_DIR_RTT_SESSIONS/$rtt_session"
 
    chmod a+rwx "$WM_DIR_RTT_SESSIONS/$rtt_session"
    screen_command="screen -d -m $WM_DIR_RTT_SESSIONS/$rtt_session" 

    #echo ${screen_command} 
    
    $(${screen_command})

    killpid=$(ps -ef | grep $rtt_session | grep SCREEN | awk {'print $2}')
    echo "kill -9 $killpid" > $WM_DIR_RTT_SESSIONS/$rtt_session 
    echo "rm \$0" >> $WM_DIR_RTT_SESSIONS/$rtt_session 

    chmod a+rxw $WM_DIR_RTT_SESSIONS/$rtt_session


}