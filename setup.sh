#!/usr/bin/env bash
# Wirepas Oy

set -o nounset
set -o errexit
set -o errtrace


function _defaults
{
    GCC_ARCHIVE=${GCC_ARCHIVE:-"gcc-arm-none-eabi-4_8-2014q3-20140805-linux.tar.bz2"}
    GCC_INSTALL_PATH=${GCC_INSTALL_PATH:-"${HOME}/opt"}

    ARCHITECTURE=$(uname -m)

    if [ "${ARCHITECTURE}" == "armv7l" ]
    then
        JLINK_ARCHIVE=${JLINK_ARCHIVE:-"JLink_Linux_arm.tgz"}
    else
        JLINK_ARCHIVE=${JLINK_ARCHIVE:-"JLink_Linux_V644a_x86_64.tgz"}
    fi
    JLINK_INSTALL_PATH=${JLINK_INSTALL_PATH:-"${HOME}/opt"}
}



function fetch_gcc
{
    _gcc_url=https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q3-update/+download/${GCC_ARCHIVE}

    if [[ ! -f ${GCC_ARCHIVE} ]]
    then
        mkdir -p ${GCC_INSTALL_PATH}
        wget ${_gcc_url}
        tar -xjvf ${GCC_ARCHIVE} -C ${GCC_INSTALL_PATH}
        rm -r ${GCC_ARCHIVE}
    fi

    PATH="${GCC_INSTALL_PATH}/gcc-arm-none-eabi-4_8-2014q3/bin:$PATH"
}

function fetch_jlink
{
    if [[ ! -f ${JLINK_ARCHIVE} ]]
    then
        mkdir -p ${JLINK_INSTALL_PATH}
        echo "Please download SEGGER jlink:"
        echo "https://www.segger.com/downloads/jlink/${JLINK_ARCHIVE}"
        echo ""
        read -n 1 -s -r -p "Press any key to continue"
        echo ""
        if [[ ! -f ${JLINK_ARCHIVE} ]]
        then
            echo "Please move the archive to $(pwd)"
            read -n 1 -s -r -p "Press any key to continue"
            echo ""
        fi
        tar -xvzf ${JLINK_ARCHIVE} -C ${JLINK_INSTALL_PATH}
        rm -r ${JLINK_ARCHIVE}
    fi

    PATH="${JLINK_INSTALL_PATH}:$PATH"
}

function install_system
{
    sudo ./dependencies/packages.sh
}


function install_python_packages
{
    if ! which pip3
    then
        echo "installing pip3"
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        sudo -H python3 get-pip.py
    fi
    pip3 install --user -r ./dependencies/requirements.txt
}


function _main
{
    _defaults
    install_system
    install_python_packages
    fetch_gcc
    fetch_jlink
}

_main "${@}"
