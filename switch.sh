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

# WORK_MONITOR_SERIAL_NUMBER=205NDEZ77508
# #MONITOR\GSM58C8\{4d36e96e-e325-11ce-bfc1-08002be10318}\0003
HOME_MONITOR=MONITOR\GSM58C9\{4d36e96e-e325-11ce-bfc1-08002be10318}\0006
WORK_MONITOR=205NDEZ77508
HOME_MONITOR_INPUT_NUMBER=4
WORK_MONITOR_INPUT_NUMBER=3

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
    sendHidCommand ${MOUSE_NUMBER} ${MOUSE_CHANNEL_PREFIX} ${channel}
}

switchDisplayTo() {
    displayId=$1
    inputNumber=$2
    ./ControlMyMonitor.exe  /SetValue ${displayId} 60 ${inputNumber}
}

switchEverything() {
    source=$1
    target=$2

    if [[ "$source" == "home" ]]; then
        currentDisplay=${HOME_MONITOR}
    elif [[ "${source}" == "work" ]]; then
        currentDisplay=${WORK_MONITOR}
    else
        echo Invalid source \'${source}\'
        exit -1
    fi

    if [[ "$target" == "home" ]]; then
        channel=${HOME_CHANNEL}
        displayInput=${HOME_MONITOR_INPUT_NUMBER}
    elif [[ "$target" == "work" ]]; then
        channel=${WORK_CHANNEL}
        displayInput=${WORK_MONITOR_INPUT_NUMBER}
    else
        echo Invalid target "${target}"
        exit -1
    fi

    echo Switching from \'${source}\' to \'${target}\'

    switchKeyboardTo ${channel}
    switchMouseTo ${channel}
    switchDisplayTo "${currentDisplay}" "${displayInput}"
}

host=$(hostname)
if [[ "${host}" == "5CG1335TX4" ]]; then
    source=work
elif [[ "${host}" == "evan-asus" ]]; then
    source=home
else
    echo Unable to determine host to switch to automatically. 
    exit -1
fi


if  [ "$#" -gt 0 ]; then
    if [[ "$1" == 'home' ]]; then
        target=home
    elif [[ "$1" == 'work' ]]; then
        target=work
    else 
        echo Invalid target '$1'
        exit -1
    fi
else
    if [[ "${source}" == "home" ]]; then
        target=work
    elif [[ "${source}" == "work" ]]; then
        target=home
    fi
fi

switchEverything "${source}" "${target}"
