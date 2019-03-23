#!/usr/bin/env bash
# Wirepas Oy

function log_menu
{
    option=$(ui_log_menu)

    exitstatus=$?

    if [[ $exitstatus == 0 ]]
    then
        echo ${option}
        exit 0
    else
        echo "0"
        exit 1
    fi
}


function log_kill_session_menu
{
    ses_ids=$(rtt_find_sessions "(SESSION)")

    ses_ids_arr=($ses_ids)
    ses_ids_len=${#ses_ids_arr[@]}

    if [[ ${#ses_ids} == 0 ]]
    then
        exit 1
    fi

    for id in $ses_ids; do
        if ((${#first} == 0)); then
            cl_ids="$id $id 1"
            first=false
        else
            cl_ids="$cl_ids $id $id 0"
        fi
    done

    #todo: move to whip_ui.sh
    sessions=$(whiptail --notags --title "Segger JLink USB" --checklist "Choose sessions $1" \
        15 30 $ses_ids_len \
        $cl_ids \
        3>&1 1>&2 2>&3)

    stat=$?
    if [[ $stat != 0 ]]
    then
        exit 1
    fi

    echo ${sessions//\"/}

    exit 0
}



function log_device_menu
{
    devices=$(device_get_ids "(LOGGER)")

    if [[ ${#devices} == 0 ]]
    then
        err="No devices connected."
        ui_errorbox "$err"
        echo $err
        exit 1
    fi

    for dev in $devices; do
        port=$(find_free_port)
        rtt_start_session $dev $port
    done
}

function log_main_menu
{
      if [[ "$@"=="0" ]]
      then
          option=$(log_menu)
      fi

      if [[ $option -eq 1 ]]
      then

          log_device_menu

      elif [[ $option -eq 2 ]]
      then

          sessions=$(log_kill_session_menu)

          if [[ -z "$sessions"  ]]
          then
              ui_errorbox "No Sessions"
              exit 1

          fi

          for session in $sessions; do
             ui_debug "DELETE $session"
             rtt_delete_session $session
          done
          
      elif [[ $option -eq 3 ]]
      then
        sessions=$(rtt_find_sessions)

        if [[ -z "$sessions"  ]]
        then
            echo "No RTT Sessions"
            exit 0
        else
            echo ${sessions}
        fi

      fi

      exit 0
}
