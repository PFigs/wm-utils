#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */


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



# $1 Segger ID
# $2 Telnet Port

function rtt_start_session()
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


function rtt_find_sessions()
{
    echo $(ps -ef | grep SCREEN | grep .rttsessions | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)   
}

#$1 telnet port
function rtt_connect_port()
{
    JLinkRTTClient -RTTTelnetPort $1    
}

if [[ "$BASH_SOURCE" == "$0" ]]
then
    rtt_find_sessions
fi
