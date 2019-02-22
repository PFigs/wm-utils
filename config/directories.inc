
###############################################################################
#system directories
WM_DIR_COMMON=${WM_ROOT_DIR}/common
WM_DIR_CONFIG=${WM_ROOT_DIR}/config
###############################################################################
#scripts
###############################################################################
#build menu

SCRIPT_BUILD_MENU=${WM_DIR_COMMON}/buildmenu.sh
SCRIPT_DEVICE_MENU=${WM_DIR_COMMON}/devmenu.sh
SCRIPT_FLASH_MENU=${WM_DIR_COMMON}/flashmenu.sh
SCRIPT_ERASE_MENU=${WM_DIR_COMMON}/erasemenu.sh
SCRIPT_LOG_MENU=${WM_DIR_COMMON}/logmenu.sh
SCRIPT_PARSE_ARGS=${WM_DIR_COMMON}/parse.sh
SCRIPT_MAIN_MENU=${WM_DIR_COMMON}/mainmenu.sh

SCRIPT_RUN_ACTION=${WM_DIR_COMMON}/run_action.sh

###############################################################################
#common scripts
UI_SCRIPTS=${WM_DIR_COMMON}/whip_ui.sh
###############################################################################
#JLINK
FLASH_JLINK=${WM_DIR_CONFIG}/flash.jlink
ERASE_JLINK=${WM_DIR_CONFIG}/erase.jlink
###############################################################################
#WM_DIR_SDK=sdk
#DIR_IMAGES=${WM_ROOT_DIR}/images
#Override with user config
source "$WM_DIR_CONFIG/user.conf"
