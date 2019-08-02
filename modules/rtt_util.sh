#!/usr/bin/env bash
# Copyright 2019 Wirepas Ltd licensed under Apache License, Version 2.0


#find free tcp port
function find_free_port
{
    lowerport=19200
    upperport=19999

    while :
    do
        port=$(shuf -i ${lowerport}-${upperport} -n 1)
        ss -lpn | grep -q ":$port " || break
    done
    echo ${port}
}


# $1 Segger ID
# $2 Telnet Port
function rtt_start_session
{

    if [[ -z $1 ]]
    then
        echo "RTT START SESSION: device id missing"
        exit 1
    fi

    if [[ -z $2 ]]
    then
        echo "RTT START SESSION: session port missing"
        exit 1
    fi



    rtt_session="$1_$2.sh"

    ui_debug "rtt_session"

    mkdir -p ${WM_UTS_RTT_SESSIONS}

        # Set device only if it is not already set via env
    if [[ ${#WM_JLINK_DEVICE} == 0 ]]
    then
        WM_JLINK_DEVICE=${EFR}
    fi

    rtt_command="JLinkExe SelectEmuBySN $1 -device $WM_JLINK_DEVICE -if SWD -speed auto -AutoConnect 1 -RTTTelnetPort $2"

    ui_debug ${rtt_command}

    echo ${rtt_command} > "$WM_UTS_RTT_SESSIONS/$rtt_session"

    chmod a+rwx "$WM_UTS_RTT_SESSIONS/$rtt_session"
    screen_command="screen -d -m $WM_UTS_RTT_SESSIONS/$rtt_session"

    ui_debug ${screen_command}

    $(${screen_command})

    killpid=$(ps -ef | grep $rtt_session | grep SCREEN | awk {'print $2}')
    echo "kill -9 $killpid" > $WM_UTS_RTT_SESSIONS/$rtt_session
    echo "rm \$0" >> $WM_UTS_RTT_SESSIONS/$rtt_session

    chmod a+rxw $WM_UTS_RTT_SESSIONS/$rtt_session
}

#finds session pid from ps ands kills it
#$1 session id
function rtt_kill_session
{
     #echo "KILL $1"
     pid=$(ps -ef | grep SCREEN | grep $1 | cut -d ' ' -f2)

     if [[ -z "${pid}" ]]
     then
         echo "session not found"
         exit 1
     fi

     ui_debug "Kill Session: $1 Pid: $pid"

     cmd="kill -9 $pid"

     echo ${cmd}

     $(${cmd})
}

#kills session using session file
#$1 session id
function rtt_delete_session
{
    if [[ -z $1 ]]
    then
        echo "RTT START SESSION: session id missing"
        exit 1
    fi


    file="$WM_UTS_RTT_SESSIONS/$1.sh"

    if [[ -f $file ]]
    then
        ui_debug "Session File $FILE exists."
        exec $file
        exit 0
    else
        ui_debug "Session File $file does not exist."
        #fallback, kill with PID
        rtt_kill_session "$1"
        exit $?
    fi
}

function rtt_find_sessions
{
    echo $(ps -ef | grep SCREEN | grep .rttsessions | rev | cut -d '/' -f1 | rev | cut -d '.' -f1)
}

#$1 telnet port
function rtt_connect_port
{
    JLinkRTTClient -RTTTelnetPort $1
}

if [[ "$BASH_SOURCE" == "$0" ]]
then
    rtt_find_sessions
fi
