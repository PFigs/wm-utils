#!/usr/bin/env bash
# Wirepas Oy

#set -o nounset
set -o errexit
set -o errtrace
#set -x

## _import_modules
## sources auxiliary functions needed for the runtime operation
## of wm-utils
function _import_modules
{
    for CFILE in ${WM_UTS_SERVICE_HOME}/modules/*.sh
    do
        source ${CFILE} 
    done

    trap 'wmutils_error "${BASH_SOURCE}:${LINENO} (rc: ${?})"' ERR
    trap 'wmutils_finish "${BASH_SOURCE}"' EXIT
}


## _defaults
## sources main functions and stores information regarding the location of
## the script execution.
function _defaults
{
    WM_UTS_VERSION="#FILLVERSION"
    HOST_ARCHITECTURE=$(uname -m)

    WM_UTS_SERVICE_HOME=${WM_UTS_SERVICE_HOME:-"${HOME}/wirepas/wm-utils"}
    
    set -o allexport
    source "${WM_UTS_SERVICE_HOME}/environment/directories.env"
    source "${WM_UTS_SERVICE_HOME}/environment/user.env"

    PATH=$PATH:/home/${USER}/.local/bin
    PATH=${PATH}:${WM_UTS_GCC_INSTALL_PATH}
    PATH=${PATH}:${WM_UTS_JLINK_INSTALL_PATH}
    set +o allexport
}


function wmutils_error
{
    echo "exit due to error at ${@}"
}

function wmutils_finish
{
    exit
}

function main
{
    #check command line arguments
    if [[ $# -gt 0 ]]
    then
        parse_args "$@"
        exit $?
    else
        selection=0    
    fi
 

    if [[ $? -eq 1 ]]
    then
        #exit on error
        exit $?
    fi

    if [[ ${selection} == "0" ]]
    then
        #enter main menu
        selection=$(main_menu)
    else
        exit 0    
    fi

    if [[ $? -eq 1 ]]
    then
        #exit on cancel
        exit $?
    fi


    if [[ -z ${selection} ]]
    then
        exit 1
    fi

    # do something $SELECTION has number of actions
    run_action ${selection}
    exit 0
}


_defaults
_import_modules
main "$@"
exit $?
