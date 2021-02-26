#!/bin/bash


if [ -f /home/pi/.bashrc ]; then
    
    checkBashrc=$(grep "alias menu='cd ~/player-pi  && ./menu.sh'" /home/pi/.bashrc)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        echo "Prawdopodobnie player-pi zostal zainstalowany. Wywolaj polecenie 'menu' w terminalu"
    else
        echo "alias menu='cd ~/player-pi  && ./menu.sh'" >> /home/pi/.bashrc
        sudo echo "cd /home/pi/player-pi/ && sudo screen -dmS main ./player.sh" >> /home/pi/.bashrc
        sudo echo "player-pi zostal pomysle zainstalowany. Wpisz 'menu' w terminalu"
    fi
else
    echo "Twoj system operacyjny nie posiada pliku bahrc"
fi