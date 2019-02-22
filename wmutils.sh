#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */


################################################################################
# Initialize paths etc
################################################################################
# Full path of the current script
this=$(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0)
# The directory where current script resides
WM_ROOT_DIR=$(dirname "${this}")
 
# 'Dot' means 'source', i.e. 'include':
source "${WM_ROOT_DIR}/config/directories.inc"
#import all functions
source "${WM_DIR_COMMON}/scripts.env"


###############################################################################
function main()
{
    #check command line arguments
    selection=$(parse_args "$@")

    if [ $? -eq 1 ];then
        #exit on error
        exit $?
    fi

    if [ ${selection} == "0" ]; then
        #enter main menu
        selection=$(main_menu)
    fi

    if [ $? -eq 1 ];then
        #exit on cancel
        exit $?
    fi

    # do something $SELECTION has number of actions
    run_action ${selection}

    exit 0

}

main "$@"


exit $?