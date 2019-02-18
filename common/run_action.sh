#!/bin/bash

#!/bin/bash

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




function build()
{
    echo "BUILD"
}

function log()
{
    echo "LOG"
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