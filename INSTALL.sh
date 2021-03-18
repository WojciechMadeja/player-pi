#!/bin/bash


if [ -f /home/pi/.bashrc ]; then
    
    checkBashrc=$(grep "alias menu='cd ~/player-pi  && ./menu.sh'" /home/pi/.bashrc)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        echo "Prawdopodobnie player-pi zostal zainstalowany. Wywolaj polecenie 'menu' w terminalu"
    else
        echo "alias menu='cd ~/player-pi  && ./menu.sh'" >> /home/pi/.bashrc
        sudo echo "player-pi zostal pomysle zainstalowany. Wpisz 'menu' w terminalu"
    fi
else
    echo "Twoj system operacyjny nie posiada pliku bahrc"
fi

if [ -f /etc/crontab ]; then
    
    checkBashrc=$(grep "@reboot root cd /home/pi/player-pi/ && ./player.sh" /etc/crontab)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        echo "Prawdopodobnie player-pi juz uruchamia sie ze startem systemuu"
    else
        sudo echo "@reboot root cd /home/pi/player-pi/ && ./player.sh" | sudo tee -a /etc/crontab
        sudo echo "player-pi bedzie uruchamial sie ze startem systemu"
    fi
else
    echo "Twoj system operacyjny nie posiada pliku crontab"
fi