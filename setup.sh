#!/usr/bin/env bash
# Wirepas Oy

set -o nounset
set -o errexit
set -o errtrace

INSTALL_SYSTEM_PKG=${1:-"false"}

BUILD_VERSION="1.0.0"

function setup_defaults
{
    HOST_ARCHITECTURE=$(uname -m)

    INSTALL_SYSTEM_WIDE="false"
    WM_UTS_SERVICE_HOME=${HOME}/wirepas/wm-utils
    WM_UTS_EXEC_NAME="wm-utils"
    WM_UTS_INSTALL_PATH=${HOME}/.local/bin
    WM_UTS_ENVIRONMENT_CUSTOM="${WM_UTS_SERVICE_HOME}/environment/user.env"

    WM_UTS_GCC_VERSION=gcc-arm-none-eabi-4_8-2014q3
    WM_UTS_GCC_INSTALL_PATH=${WM_UTS_GCC_INSTALL_PATH:-"${HOME}/opt"}
    GCC_ARCHIVE=${GCC_ARCHIVE:-"${WM_UTS_GCC_VERSION}-20140805-linux.tar.bz2"}

    if [ "${HOST_ARCHITECTURE}" == "armv7l" ]
    then
        WM_UTS_JLINK_VERSION="JLink_Linux_arm"
        JLINK_ARCHIVE="JLink_Linux_arm.tgz"
    else
        WM_UTS_JLINK_VERSION="JLink_Linux_V644a_x86_64"
        JLINK_ARCHIVE="${WM_UTS_JLINK_VERSION}.tgz"
    fi
    WM_UTS_JLINK_INSTALL_PATH=${WM_UTS_JLINK_INSTALL_PATH:-"${HOME}/opt"}


    #todo: write it to user.env
    mkdir -p ${WM_UTS_SERVICE_HOME}
    mkdir -p ${WM_UTS_JLINK_INSTALL_PATH}
    mkdir -p ${WM_UTS_GCC_INSTALL_PATH}

    export PATH=${PATH}:${WM_UTS_INSTALL_PATH}
}




function update_path_config
{
    _KEY=${1}
    _VALUE=${2}

    echo "removing ${_KEY} from env files"
    sed -i "/${_KEY}/d" ${WM_UTS_ENVIRONMENT_CUSTOM}
    echo "${_KEY}=${_VALUE}" >> ${WM_UTS_ENVIRONMENT_CUSTOM}

}


function setup_gcc
{
    _gcc_url=https://launchpad.net/gcc-arm-embedded/4.8/4.8-2014-q3-update/+download/${GCC_ARCHIVE}

    if [[ ! -f ${GCC_ARCHIVE} ]]
    then
        mkdir -p ${WM_UTS_GCC_INSTALL_PATH}
        wget ${_gcc_url}
        tar -xjvf ${GCC_ARCHIVE} -C ${WM_UTS_GCC_INSTALL_PATH}
    fi

    export PATH="${WM_UTS_GCC_INSTALL_PATH}/${WM_UTS_GCC_VERSION}/bin:$PATH"
}

function setup_jlink
{
    if [[ ! -f ${JLINK_ARCHIVE} ]]
    then
        mkdir -p ${WM_UTS_JLINK_INSTALL_PATH}
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
        tar -xvzf ${JLINK_ARCHIVE} -C ${WM_UTS_JLINK_INSTALL_PATH}
    fi

    export PATH="${WM_UTS_JLINK_INSTALL_PATH}:$PATH"
}

function setup_system_packages
{
    sudo ./dependencies/packages.sh
}


function setup_python
{
    if ! which pip
    then
        echo "installing pip"
        curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
        sudo -H python get-pip.py
    fi
    pip install --user -r ./dependencies/requirements.txt
}


function setup_wmutils
{
    if [[ -f ${WM_UTS_SERVICE_HOME}/bin/wm-utils.sh  ]]
    then
        echo "copying exec from bundle"
        _is_clone=false
    elif [[ -f $(pwd)/bin/wm-utils.sh  ]]
    then
        echo "assuming git clone: setting up ${WM_UTS_SERVICE_HOME}"
        export BUILD_VERSION=$(git log -n 1 --oneline --format=%h)

        echo "setting up ${WM_UTS_SERVICE_HOME}"
        rsync -av  . ${WM_UTS_SERVICE_HOME} \
              --exclude .git \
              --exclude setup.sh \
              --exclude *tar* \
              --exclude *.tgz \
              --exclude *.tmp \
              --exclude *.*ignore

        _is_clone=true
    fi

    update_path_config WM_UTS_GCC_INSTALL_PATH ${WM_UTS_GCC_INSTALL_PATH}/${WM_UTS_GCC_VERSION}/bin
    update_path_config WM_UTS_JLINK_INSTALL_PATH ${WM_UTS_JLINK_INSTALL_PATH}/${WM_UTS_JLINK_VERSION}

    # copy and set permissions
    if [[ ${INSTALL_SYSTEM_WIDE} == true ]]
    then
        echo "installing wm-utils system wide"
        sudo ln -s ${WM_UTS_SERVICE_HOME}/bin/wm-utils.sh ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}
        sudo chmod +x ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}
    else
        echo "installing wm-utils for current user"

        rm -Rf ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}

        mkdir -p /home/${USER}/.local/bin || true
        ln -s ${WM_UTS_SERVICE_HOME}/bin/wm-utils.sh ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}
        chmod +x ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}


        export PATH=$PATH:/home/${USER}/.local/bin
        _set_build_number ${WM_UTS_SERVICE_HOME}/bin/wm-utils.sh
    fi
}

function _set_build_number
{
    _targets=("$@")

    # sets the hash if possible
    for _target in "${_targets[@]}";
    do
        echo "filling version ${BUILD_VERSION} on: ${_target}"
        cp ${_target} ${_target}.tmp
        sed -i "s/#FILLVERSION/$(date +%F) - ${BUILD_VERSION}/g" ${_target}
        rm ${_target}.tmp
    done
}

function _restore_build_number
{
    _targets=("$@")
    for _target in "${_targets[@]}"
    do
        echo "reseting: ${_target}"
        cp ${_target}.tmp ${_target}
    done
}

function _main
{
    setup_defaults
    rm -rf ${WM_UTS_SERVICE_HOME}
    rm -rf ${WM_UTS_INSTALL_PATH}/${WM_UTS_EXEC_NAME}

    if [[ "${INSTALL_SYSTEM_PKG}" == "true" ]]
    then
        setup_system_packages
        setup_python
    fi

    setup_gcc
    setup_jlink
    setup_wmutils
}

_main "${@}"
