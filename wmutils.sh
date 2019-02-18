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



flash_menu $DIR_IMAGES

erase_menu




