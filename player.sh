#!/bin/bash


fnVol(){
    vol=$(cat value/volume$1.txt)
    amixer -c $2 set PCM  $vol%
}

fnPlSim(){
    ckeckSession=$(sudo screen -ls kanal$1)
    exitstatus=$?
    if [ $exitstatus = 0 ]; then
        true
    else
        sudo screen -dmS kanal$1 omxplayer $4 -o alsa:hw:$2,0 /home/pi/player-pi/sound/$3.mp3
    fi
}

fnPlOnce(){
    sudo omxplayer -o alsa:hw:$1,0 /home/pi/player-pi/sound/$2.mp3
}

fnOff(){
    sessionName="kanal$1"
    sudo screen -ls "$sessionName" | (
    IFS=$(printf '\t');
    sed "s/^$IFS//" |
    while read -r name stuff; do
        sudo screen -S "$name" -X quit
    done
    )
}

fnVol "1" "Device"
fnVol "2" "Device_1"
fnVol "3" "Device_2"
fnVol "3" "Device_3"


while true; do
    hourBegin=$(cat value/hourBegin.txt)
    hourEnd=$(cat value/hourEnd.txt)
    hourNow=`date +%-H`
    sinceTime=$(awk '{print int($0/60/60/24); }' /proc/uptime)
    if [[ $hourNow -ge $hourBegin ]] && [[ $hourNow -lt $hourEnd ]]; then
        while true; do
            hourNow=`date +%-H`
            hourEnd=$(cat value/hourEnd.txt)
            fnPlSim "1" "Device_1" "1" "--loop"
            fnPlSim "2" "Device_2" "2"
            sleep 1m
            fnPlOnce "Device" "3"

            if [[ $hourNow -eq $hourEnd ]]; then
                
                fnOff "1"
                fnOff "2"
                break
            fi
        done
    
    elif [[ $sinceTime -ge 2 ]] && [[ $hourNow -ge 22 ]]; then
        sudo reboot now
    fi
done
