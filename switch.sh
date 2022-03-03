#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


CONFIG=${SCRIPT_DIR}/config.yml

hidapitester=${SCRIPT_DIR}/hidapitester.exe
controlmymonitor=${SCRIPT_DIR}/ControlMyMonitor.exe

configValue() {
    valu=`yq $1 ${CONFIG}`
    if [[ "${valu}" == "null" ]]; then
        echo "Missing value '$1' in ${CONFIG}"  >&2
        exit -1
    fi
    echo "${valu}"
}


sendHidSwitchCommand() {
    local deviceType=$1
    local target=$2

    local vidpid=$(configValue .${target}.logitech.receiver.vid):$(configValue .${target}.logitech.receiver.pid)
    local deviceNumber=$(configValue .${target}.logitech.${deviceType}.number)
    local channelPrefix=$(configValue .${target}.logitech.${deviceType}.channelPrefix)
    local receiverChannel=$(configValue .${target}.logitech.receiver.channel)

    ${hidapitester} \
        --vidpid ${vidpid} \
        --usage 0x0001 \
        --usagePage 0xFF00 \
        --open \
        --length 7 \
        --send-output 0x10,${deviceNumber},${channelPrefix},${receiverChannel},0x00,0x00
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
