#!/bin/bash


fnVol(){
    vol=$(cat value/volume$1.txt)
    amixer -c $2 set PCM  $vol%
}

fnPlSim(){
    screen -dmS kanal$1 omxplayer $4 -o alsa:hw:$2,0 /home/pi/player-pi/sound/$3.mp3
}

fnPlOnce(){
    omxplayer -o alsa:hw:$1,0 /home/pi/player-pi/sound/$2.mp3
}

fnOff(){
    sessionName="kanal$1"
    screen -ls "$sessionName" | (
    IFS=$(printf '\t');
    sed "s/^$IFS//" |
    while read -r name stuff; do
        screen -S "$name" -X quit
    done
    )
}

fnVol "1" "Device"
fnVol "2" "Device_1"
fnVol "3" "Device_2"


while true; do
    hourBegin=$(cat value/hourBegin.txt)
    hourEnd=$(cat value/hourEnd.txt)
    hourNow=`date +%-H`
    sinceTime=$(awk '{print int($0/60/60/24); }' /proc/uptime)
    if [[ $hourNow -ge $hourBegin ]] && [[ $hourNow -lt $hourEnd ]]; then
        while true; do
            hourNow=`date +%-H`
            hourEnd=$(cat value/hourEnd.txt)

                       
            fnPlSim "1" "Device" "ogienKon" 
            fnPlSim "2" "Device_1" "rozmowaStukanie"
            fnPlSim "3" "Device_2" "stukanieRabanieZew" 
           
            sleep 9m 10s
            sudo killall screen
            sleep 1m

            hourNow=`date +%-H`
            hourEnd=$(cat value/hourEnd.txt)

            if [[ $hourNow -eq $hourEnd ]]; then
                
                fnOff "1"
                fnOff "2"
                sudo killall screen
                break
            fi
        done
    
    elif [[ $sinceTime -ge 2 ]] && [[ $hourNow -ge 22 ]]; then
        sudo reboot now
    fi
done
