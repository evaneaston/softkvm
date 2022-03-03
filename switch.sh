#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

CONFIG=${SCRIPT_DIR}/config.yml

hidapitester=${SCRIPT_DIR}/hidapitester.exe
controlmymonitor=${SCRIPT_DIR}/ControlMyMonitor.exe

configValue() {
    # yq config.yml -o json |  jq 'del(.logitech)'
    local value=`yq "$1" ${CONFIG}`
    if [[ "${value}" == "null" ]] || [[ "${value}" == "" ]]; then
        echo "Missing value '$1' in ${CONFIG}"  >&2
        exit -1
    fi
    echo "${value}"
}


sendHidSwitchCommand() {
    local deviceType=$1
    local target=$2

    local vidpid=$(configValue .${target}.logitech.receiver.vid):$(configValue .${target}.logitech.receiver.pid)
    local deviceNumber=$(configValue .${target}.logitech.${deviceType}.number)
    local channelPrefix=$(configValue .${target}.logitech.${deviceType}.channelPrefix)
    local receiverChannel=$(configValue .${target}.logitech.receiver.channel)

#set -x
    ${hidapitester} \
        --vidpid ${vidpid} \
        --usage 0x0001 \
        --usagePage 0xFF00 \
        --open \
        --length 7 \
        --send-output 0x10,${deviceNumber},${channelPrefix},${receiverChannel},0x00,0x00
#set +x
}

switchDisplayTo() {
    displayId=$1
    inputNumber=$2
    ${controlmymonitor} /SetValue "${displayId}" 60 ${inputNumber}
}

switchEverything() {
    source=$1
    target=$2

    currentDisplay=$(configValue .${source}.displays.external )
    channel=$(configValue .${target}.logitech.receiver.channel )
    displayInput=$(configValue .${target}.displays.externalInputNumber )

    echo Switching from \'${source}\' to \'${target}\'
    sendHidSwitchCommand "keyboard" "$target"
    sendHidSwitchCommand "mouse" "$target"
    switchDisplayTo "${currentDisplay}" "${displayInput}"
}

getSource() {
    local hostname=$(hostname)
    echo $(configValue "del(.logitech)|.[]|select(.hostname==\"${hostname}\")|key")
}
<<<<<<< HEAD


=======


>>>>>>> 296257d... Fixes
switch() {
    local source=$(getSource)
    local target
    if  [ "$#" -gt 0 ]; then
        target=$(configValue "del(.logitech)|.${1}|key")
    else
        alternatives=$(configValue "del(.logitech)|del(.${source})|.[]|key")
        if [ "$(echo $alternatives | wc -w)" -eq 1 ]; then 
            target=${alternatives}
        else
            echo Please specific a target of one of: ${alternatives}
            exit 9
        fi
    fi
    switchEverything  "${source}" "${target}"
}

wakeCurrentExternalMonitor() {
    local source=$(getSource)
    local monitorId=$(configValue ".${source}.displays.external")
    ${controlmymonitor} /TurnOn "${monitorId}"
}

if [ $# -eq 0 ]; then
    switch
elif [ "$1:" == "wake" ]; then
    wakeCurrentExternalMonitor
elif [ "$1" == "switch" ]; then
    switch
fi



