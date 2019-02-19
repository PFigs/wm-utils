#!/bin/bash

if [[ "$BASH_SOURCE" == "$0" ]]
then
    echo "Please run wmutils.sh"
    exit
fi



# 'Dot' means 'source', i.e. 'include':
 . "$SCRIPT_BUILD_MENU"
 . "$SCRIPT_DEVICE_MENU"
 . "$SCRIPT_FLASH_MENU"
 . "$SCRIPT_ERASE_MENU"
 . "$SCRIPT_MAIN_MENU"
 . "$SCRIPT_PARSE_ARGS"
 . "$SCRIPT_RUN_ACTION"