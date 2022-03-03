#!/bin/bash

RCVR_VID=046D
RCVR_PID=C52B

HOME_CHANNEL=0x00
WORK_CHANNEL=0x01

KEYBOARD_NUMBER=0x01
MOUSE_NUMBER=0x02

KEYBOARD_CHANNEL_PREFIX=0x09,0x1e
MOUSE_CHANNEL_PREFIX=0x0a,0x1b

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
switchTo() {
    channel=$1
    sendHidCommand ${KEYBOARD_NUMBER} ${KEYBOARD_CHANNEL_PREFIX} ${channel}
    sendHidCommand ${MOUSE_NUMBER}    ${MOUSE_CHANNEL_PREFIX}    ${channel}
}

switchTo ${WORK_CHANNEL}

# # Switch MX Keys to other device
# ./hidapitester.exe \
#      --vidpid ${RCVR_VID}:${RCVR_PID} \
#     --usage 0x0001 \
#     --usagePage 0xFF00 \
#     --open \
#     --length 7 \
#     --send-output 0x10,${KEYBOARD_NUMBER},0x09,0x1e,${WORK},0x00,0x00


# # Switch MX Mouse to other device
# ./hidapitester.exe \
#     --vidpid ${RCVR_VID}:${RCVR_PID} \
#     --usage 0x0001 \
#     --usagePage 0xFF00 \
#     --open \
#     --length 7 \
#     --send-output 0x10,0x02,0x0a,0x1b,0x01,0x00,0x00

# exit 0

