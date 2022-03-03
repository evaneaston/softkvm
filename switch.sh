#!/usr/bin/env bash
set -euo pipefail

RCVR_VID=046D
RCVR_PID=C52B

HOME_CHANNEL=0x00
WORK_CHANNEL=0x01

KEYBOARD_NUMBER=0x01
MOUSE_NUMBER=0x02

KEYBOARD_CHANNEL_PREFIX=0x09,0x1e
MOUSE_CHANNEL_PREFIX=0x0a,0x1b

usage() {
    echo "Usage $0 {-f} {-v 4|6} hostname ipaddress\n\n  -f     FQDN only.  Sets registerNonQualified=false on the host record.  Defaults to true.\n  -v     4 or 6.  Defaults to 4.  Ignored by UDM firmware < 1.9.\n"
}

sendHidCommand() {
    deviceNumber=$1
    channelPrefix=$2
    receiverChannel=$3
    ./hidapitester.exe \
        --vidpid ${RCVR_VID}:${RCVR_PID} \
        --usage 0x0001 \
        --usagePage 0xFF00 \
        --open \
        --length 7 \
        --send-output 0x10,${deviceNumber},${channelPrefix},${receiverChannel},0x00,0x00
}

switchKeyboardTo() {
   channel=$1
   sendHidCommand ${KEYBOARD_NUMBER} ${KEYBOARD_CHANNEL_PREFIX} ${channel}
}

switchMouseTo() {
   channel=$1
   sendHidCommand ${MOUSE_NUMBER}    ${MOUSE_CHANNEL_PREFIX}    ${channel}
}


switchTo() {
    channel=$1
    switchKeyboardTo ${channel}
    switchMouseTo ${channel}    
}

switchTo ${WORK_CHANNEL}

