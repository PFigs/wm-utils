WM-UTILS
========

WM-UTILS allows you to build, flash and log (requires RTT access)
all the devices connected to your host in a blink of an eye.

WM-UTILS runs over bash shell and it's built around JLink tools and GNU make.

WM-UTILS has support for an `interactive`_ and `non-interactive`_ session.

In the interactive session, you pick your choices from a menu.

In the non-interactive session, you define what WM-UTILS should do with a
single command line mode.


Configuration
=============

WM-UTILS requires sane configuration parameters in order to operate correctly.

The config/user.env file defines the user configuration regarding the location
of the WM SDK and the device model to connect to.

==================================================  ===================================================================================
**Variable**                                          **Definition**
==================================================  ===================================================================================
**WM_UTS_SDK_PATH**                                   Defines the path to the WM SDK
**WM_UTS_SDK_IMAGES_PATH**                            Defines the path to the WM binary images (defaults to ${WM SDK}/build)
**WM_UTS_DEVICE_EFR**                                 The EFR device model being targeted (defaults to EFR32MG12P332F1024GL125)
**WM_UTS_DEVICE_NRF**                                 The NRF device model being targeted (defaults to nrf52)
**WM_DEFAULT_JLINK_DEVICE**                           Which platform to target (NRF or EFR)
**WM_CFG_SETTINGS_IMAGE**                             The registry and name of the docker image containing the wm-utils settings
**WM_CFG_SETTINGS_VERSION**                           The image tag to pull
==================================================  ===================================================================================


.. _interactive:
Interactive mode
================

Building
---------
Select project to build from the menu. New projects are added automatically to the list.


Flashing
---------
Connect devices using USB. Select connected devices to be flashed and desired firmware hex file.


Erasing
--------
Connect devices using USB. Select connected devices to be erased.


Logging
--------

*This is an internal feature as it requires access to the RTT ports*

Connect devices using USB. Select devices where logging should be started.
JLinkExe is ran in the background screen session.

RTT connection can be established to associated telnet port. The sessions can be found from .rttsession directory.

For each active logging session there's a file, for example 000440108848_19745.sh, where 000440108848 is the device id and
19745 is the telnet port. By running the script the session is killed.

Alternatively you may kill the session via menu, by selecting it from the list.



.. _non-interactive:
Non-interactive mode
====================

Developers usually want to have shortcuts for the common operations. by invoking wmutils with '-h' or ' --help' the available commands are printed. ::


    Usage: ./wmutils.sh COMMAND <OPTIONS>
        --command <options>                             : flash commands
            erase --device [nodeid]                     : erase flash
            flash --device [nodeid] --file [filename]   : flash firmware image

        --list                                          : list connected devices

        --settings                                      : show settings
        --rtt <options>                                 : RTT log commands
            start --device [deviceid]                   : start logging session
            kill  --device [session id]                 : kill session
            list                                        : list sessions



License
------------
Licensed under the Apache License, Version 2.0. See LICENSE for the full license text.
