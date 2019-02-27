#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */

## _defaults
## sources main functions and stores information regarding the location of
## the script execution.
function _defaults
{
    HOST_ARCHITECTURE=$(uname -m)
    WM_ROOT_DIR=$(dirname "${this}")

    this=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0)

    source "${WM_ROOT_DIR}/config/directories.env"
    source "${WM_DIR_INCLUDE}/scripts.env"
}


function main()
{
    #check command line arguments

    if [[ $# -gt 0 ]] ; then
        parse_args "$@"
        exit $?
    else
        selection=0    
    fi
 

    if [ $? -eq 1 ];then
        #exit on error
        exit $?
    fi

    if [ ${selection} == "0" ]; then
        #enter main menu
        selection=$(main_menu)
    else
        exit 0    
    fi

    if [ $? -eq 1 ];then
        #exit on cancel
        exit $?
    fi

    # do something $SELECTION has number of actions
    run_action ${selection}
    exit 0
}

_defaults
main "$@"


exit $?