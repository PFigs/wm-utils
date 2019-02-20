#!/usr/bin/env bash

if [[ "$BASH_SOURCE" == "$0" ]]
then
    echo "Please run wmutils.sh"
    exit
fi

# 'Dot' means 'source', i.e. 'include':
 #common helpers
 source "$UI_SCRIPTS"
 #menu implementations
 source "$SCRIPT_BUILD_MENU"
 source "$SCRIPT_DEVICE_MENU"
 source "$SCRIPT_FLASH_MENU"
 source "$SCRIPT_ERASE_MENU"
 source "$SCRIPT_MAIN_MENU"
 source "$SCRIPT_PARSE_ARGS"
 #actions
 source "$SCRIPT_RUN_ACTION"
