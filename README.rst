wm-utils
========

WM-UTILS is an utility to help you get started with WM software.

Build, flash and log* all the devices connected to your host in a blink of an eye.


wm-utils is intended to be run on bash shell and it's built around JLink tools and GNU make.

configuration:
wm-utils is part of the Wirepas SDK and should have sane default settings preconfigured.

config/user.env
---------------
WM_DIR_SDK=${WM_DIR_SDK:-"${HOME}/wmsdk"}
WM_DIR_IMAGES=$WM_DIR_SDK/build

#Select default device
EFR=EFR32MG12P332F1024GL125
NRF=nrf52

#WM_DEFAULT_JLINK_DEVICE=${NRF}
WM_DEFAULT_JLINK_DEVICE=${EFR}

WM_DIR_SDK points to sample projects directory of the SDK and WM_DIR_IMAGES is the default location for the firmware images.
Default device configures JLinkExe connection correctly.

building:
---------
Select project to build from the menu. New projects are added automatically to the list.

Flashing:
---------
Connect devices using USB. Select connected devices to be flashed and desired firmware hex file. 

Erasing:
--------
Connect devices using USB. Select connected devices to be erased.

Logging:
--------
Connect devices using USB. Select devices where logging should be started. JLinkExe is ran in the background screen session.
RTT connection can be established to associated telnet port. The sessions can be found from .rttsession directory. 

For each active logging session there's a file, for example 000440108848_19745.sh, where 000440108848 is the device id and
19745 is the telnet port. By running the script the session is killed. Alternatively you may kill the session via menu, by selecting it from the list.


