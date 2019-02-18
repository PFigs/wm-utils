#!/bin/bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */


################################################################################
# Initialize paths etc
################################################################################
# Full path of the current script
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
# The directory where current script resides
DIR=`dirname "${THIS}"`
 
# 'Dot' means 'source', i.e. 'include':
. "$DIR/config/directories.inc"
#import all functions
. "$DIR_COMMON/scripts.inc"


###############################################################################

#check command line arguments
SELECTION=$(parse_args "$@")

if [ $? -eq 1 ];then
    #exit on error
    exit $?
fi

if [ $SELECTION == "0" ]; then
    #enter main menu
    SELECTION=$(main_menu)
fi

if [ $? -eq 1 ];then
    #exit on cancel
    exit $?
fi

# do something $SELECTION has number of actions
run_action $SELECTION


exit 0