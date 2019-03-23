#!/usr/bin/env bash
# Wirepas Oy

#globals
c="foo"
d="foo" 
f="foo"
l="foo" 
r="foo"
f="foo"


function _parse_long
{
    # Gather commands
    POSITIONAL=()
    while [[ $# -gt 0 ]]
    do
    key="$1"

    case $key in
        "-c" | "--command")
        #echo $1 $2 
        c=$2

        if [[ -z "${c}" ]]
        then
        
        echo "invalid command"
        usage
        exit

        fi
        shift # past argument
        shift
        ;;
        "-l" | "--list")
        c="list"
        #echo $1 $2 
        shift # past argument
        #shift
        ;;        
        "-s" | "--settings")   
        #echo $1 $2
        s="settings" 
        shift # past argument
        shift
        ;;
        "-r" | "--rtt")
        #echo $1 $2 
        r=$2

        if [[ -z "${r}" ]]
        then
            echo "invalid command"
            usage
            exit
        fi

        shift # past argument
        shift
        ;;
         "-d" | "--device")
        #echo $1 $2 
        d="$2"
        shift # past argument
        shift
        ;;
         "-h" | "--help")
        #echo $1 $2 
        h="help"
        shift # past argument
        #shift
        ;;
        "-f" | "--file")
        #echo $1 $2 
        f="$2"
        shift # past argument
        shift
        ;;                         
        "--debug" )
        set -x
        shift
        ;;                      
        *)
        echo "unknown parameter $1"
        exit 1
    esac
    done

}


function usage 
{
     echo "Usage: $0 COMMAND <OPTIONS>" 1>&2; 
     echo "    --command <options>                       : flash commands " 1>&2;
     echo "       erase --device [nodeid]                : erase flash"  1>&2; 
     echo "       flash --device [nodeid] --file [filename]  : flash firmware image"  1>&2; 
     echo "    " 1>&2;
     echo "    --list      t                             : list connected devices"  1>&2; 
     echo "    " 1>&2; 
     echo "    --settings                                : show settings" 1>&2;
     echo "    --rtt <options>                           : RTT log commands " 1>&2;
     echo "       start --device [deviceid]              : start logging session"  1>&2; 
     echo "       kill  --device [session id]            : kill session"  1>&2;  
     echo "       list                                   : list sessions"  1>&2;      

}


function show_settings
{
    echo "Settings"

    echo "Device family: ${WM_DEFAULT_JLINK_DEVICE}"
    echo "SDK projects directory: ${WM_UTS_SDK_PATH}"
    echo "Firmware images directory: ${WM_UTS_SDK_IMAGES_PATH}"
    echo "Connected Devices"
    device_list_devices

}


function flash_device
{

    if [[ ! -z "$1" ]] && [[ ! -z "$2" ]]
    then
        jlink_flash_menu "$1" "$2"
    else
        #ui_errorbox "missing parameters"
        usage  
    fi
}

function erase_device
{
    if [[ ! -z "$1" ]]
    then
        jlink_erase_menu "$1"
    else
        #ui_errorbox "device id missing"
        usage
    fi
}


function parse_args
{
   
    if [[ $# -eq "0" ]]
    then
        exit 0
    fi

    _parse_long "$@"
 
  
    if [[ ${h} == "help" ]]
    then
       usage
       exit 0
    fi

    if [[ ${c} == "flash" ]]
    then
        flash_device $d $f
    elif [[ ${c} == "erase" ]]
    then
        erase_device $d
    elif [[ ${c} == "list" ]]
    then
        device_list_devices  
    elif [[ ${s} == "settings" ]]
    then
        show_settings
    elif [[ ${r} == "start" ]]
    then
        sessionport=$(find_free_port)
        rtt_start_session ${d} ${sessionport}
    elif [[ ${r} == "kill" ]]
    then
        rtt_delete_session ${d}
    elif [[ ${r} == "list" ]]
    then
        rtt_find_sessions
    else
        echo "Invalid command"
        usage
    fi  

    exit 0

}


if [[ "$BASH_SOURCE" == "$0" ]]
then
    parse_args "$@"
fi
