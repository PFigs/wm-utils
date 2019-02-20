#!/usr/bin/env bash

#/* Copyright 2018 Wirepas Ltd. All Rights Reserved.
# *
# * See file LICENSE.txt for full license details.
# *
# */


function parse_args()
{

if [ $# -eq "0" ]; then
    echo "0"
    exit
fi

usage() { echo "Usage: $0 [-c <flash|erase|build|log>]" 1>&2; exit 1; }

while getopts ":h:c:" o; do
    case "${o}" in
        c)
            c=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ ${c} == "build" ]; then
    echo "1"
elif [ ${c} == "log" ]; then
    echo "2"
elif [ ${c} == "flash" ]; then
    echo "3"
elif [ ${c} == "erase" ]; then
    echo "4"
else
    echo "0"
    exit 1
fi



}


#parse_args "$@"