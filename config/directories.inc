
###############################################################################
#system directories
DIR_COMMON=$DIR/common
DIR_CONFIG=$DIR/config
###############################################################################
#scripts
###############################################################################
#build menu
SCRIPT_BUILD_MENU=$DIR_COMMON/buildmenu.sh
SCRIPT_DEVICE_MENU=$DIR_COMMON/devmenu.sh
SCRIPT_FLASH_MENU=$DIR_COMMON/flashmenu.sh
SCRIPT_ERASE_MENU=$DIR_COMMON/erasemenu.sh
SCRIPT_PARSE_ARGS=$DIR_COMMON/parse.sh
SCRIPT_MAIN_MENU=$DIR_COMMON/mainmenu.sh

SCRIPT_RUN_ACTION=$DIR_COMMON/run_action.sh

###############################################################################
#JLINK
FLASH_JLINK=$DIR_CONFIG/flash.jlink
ERASE_JLINK=$DIR_CONFIG/erase.jlink
###############################################################################
#DIR_SDK=sdk
#DIR_IMAGES=$DIR/images
#Override with user config
. "$DIR_CONFIG/user.conf"
