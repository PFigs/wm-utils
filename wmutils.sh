#!/bin/bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */



# Full path of the current script
THIS=`readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0`
# The directory where current script resides
DIR=`dirname "${THIS}"`
 
# 'Dot' means 'source', i.e. 'include':
. "$DIR/config/directories.inc"
#all functions
. "$DIR_COMMON/scripts.inc"

#flash_menu $DIR_IMAGES
#erase_menu

SELECTION=$(parse_args "$@")

if [ $? -eq 1 ];then
    exit $?
fi

if [ $SELECTION == "0" ]; then
    #enter main menu
    SELECTION=$(main_menu)
fi

if [ $? -eq 1 ];then
    echo EXIT
    exit $?
fi

#echo $SELECTION

# do something
run_action $SELECTION


