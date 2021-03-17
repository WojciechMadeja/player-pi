#!/bin/bash

re='^[0-9]+$'
knalVolume1=$(cat value/volume1.txt)


fnVol(){
    c
    vol=$(cat value/volume$1.txt)
    amixer -c $2 set PCM  $vol%

    while true
    do
    choice=$(
    whiptail --title "Kanal $1" --menu \
    "Mozesz zmienic .
    Aktualny poziom głosnosci: $vol
    Wybierz, co chcesz zrobic:  " 20 78 4 \
    "1" "Vol +" \
    "2" "Vol -" \
    "3" "Powrót"  3>&1 1>&2 2>&3)

    case $choice in

        1) 
            if ! [[ $vol -ge 100 ]];then
                ((vol+=5))
            else
                vol=100
            fi
            amixer -c $2 set PCM $vol%
            
            
            echo $vol > "value/volume$1.txt"                                                     
        ;;
        2)   if ! [[ $vol -le 0 ]];then
                ((vol-=5))
            else
                 vol=0
            fi
                amixer -c $2 set PCM $vol%
                echo $vol > "value/volume$1.txt" 
        ;;
        3)
            break
        ;;
    esac
    done
}


while true
do
oldHourBegin=$(cat value/hourBegin.txt)
oldHourEnd=$(cat value/hourEnd.txt)
choice=$(
whiptail --title "Player Pi" --menu \
"Mozesz zmienic godziny pracy i poziom glosnosci playera.
Player dziala od godz. $oldHourBegin do godz. $oldHourEnd.

Wybierz, co chcesz zrobic:  " 20 78 10 \
"1" "Zmiana godziny wlaczenia playera" \
"2" "Zmiana godziny wylaczenia playera" \
"3" "Poziom glosnosci" \
"4" "Zrestartowac dzwieki" \
"5" "Wylaczyc dzwieki" \
"6" "Wlaczyc dzwieki" \
"7" "Zrestartowac Raspberry Pi" \
"8" "Wylaczenie dzwiekow po starcie systemu" \
"9" "Wlaczenie dzwiekow po starcie systemu" \
"10" "Wyjscie z programu"  3>&1 1>&2 2>&3)

case $choice in

1)
hourBegin=$(whiptail --inputbox "Podaj nowy czas:" 8 39 $oldHourBegin --title "Zmiana godziny wlaczenia playera" 3>&1 1>&2 2>&3)
                                                                        
exitstatus=$?
if [ $exitstatus = 0 ]; then
    if [ $oldHourEnd -eq $hourBegin ]; then
    whiptail --title "Informacja" --msgbox "Godz. rozpoczecia i godz. zakonczenia nie moga byc identyczne" 8 78
    hourBegin=$oldHourBegin
    elif ! [[ $hourBegin =~ $re ]] || [[ $hourBegin -lt 0 ]] || [[ $hourBegin -gt 23 ]];then
    whiptail --title "Informacja" --msgbox "Podany parametr musi byc liczba w przedziale 0-23." 8 78
    hourBegin=$oldHourBegin
    elif [ $oldHourBegin -eq $hourBegin ];then
    whiptail --title "Informacja" --msgbox "Podana godz. jest taka sama, jak aktualna. Nie dokonano zmiany." 8 78
    elif (whiptail --title "Potwierdz wybor" --yesno "Czy na pewno chcesz zmienic z godz. $oldHourBegin na godz. $hourBegin." 8 78); then
    whiptail --title "Informacja" --msgbox "Zmieniles godzine wlaczenia playera na godz. $hourBegin." 8 78
    echo $hourBegin > "value/hourBegin.txt"
    else
    whiptail --title "Informacja" --msgbox "Anulowales zmiane godziny wlaczenia playera. Aktualna godz. to $oldHourBegin." 8 78
    hourBegin=$oldHourBegin
    fi
else
    whiptail --title "Informacja" --msgbox "Anulowales zmiane godziny wlaczenia playera. Aktualna godz. to $oldHourBegin." 8 78
    hourBegin=$oldHourBegin

fi

;;
2)
hourEnd=$(whiptail --inputbox "Podaj nowy czas:" 8 39 $oldHourEnd --title "Zmiana godziny wylaczenia playera" 3>&1 1>&2 2>&3)
                                                                        
exitstatus=$?
if [ $exitstatus = 0 ]; then
    if [ $oldHourBegin -eq $hourEnd ]; then
    whiptail --title "Informacja" --msgbox "Godz. rozpoczecia i godz. zakonczenia nie moga byc identyczne" 8 78
    hourEnd=$oldHourEnd
    elif ! [[ $hourEnd =~ $re ]] || [[ $hourEnd -lt 0 ]] || [[ $hourEnd -gt 23 ]];then
    whiptail --title "Informacja" --msgbox "Podany parametr musi byc liczba w przedziale 0-23." 8 78
    hourEnd=$oldHourEnd
    elif [ $oldHourEnd -eq $hourEnd ];then
    whiptail --title "Informacja" --msgbox "Podana godz. jest taka sama, jak aktualna. Nie dokonano zmiany." 8 78
    elif (whiptail --title "Potwierdz wybor" --yesno "Czy na pewno chcesz zmienic z godz. $oldHourEnd na godz. $hourEnd." 8 78); then
    whiptail --title "Informacja" --msgbox "Zmieniles godzine wylczania playera na godz. $hourEnd." 8 78
    echo $hourEnd > "value/hourEnd.txt"
    else
    whiptail --title "Informacja" --msgbox "Anulowales zmiane godziny wylaczenia playera. Aktualna godz. to $oldHourEnd." 8 78
    hourEnd=$oldHourEnd
    fi
else
    whiptail --title "Informacja" --msgbox "Anulowales zmiane godziny wylaczenia playera. Aktualna godz. to $oldHourEnd." 8 78
    hourEnd=$oldHourEnd
fi
;;
3)
    while true
    do
    choice=$(
    whiptail --title "Wybor kanalu" --menu \
    "Wybierz kanal:  " 20 78 7 \
    "1" "Kanal 1" \
    "2" "Kanal 2" \
    "3" "Kanal 3" \
    "4" "Kanal 4" \
    "5" "Alsamixer(dla zaawansowanych)" \
    "6" "Powrot"  3>&1 1>&2 2>&3)

    case $choice in
            1)
                fnVol "1" "Device"
            ;;
            2)
                fnVol "2" "Device_1"
            ;;
            3)
                fnVol "3" "Device_2" 
            ;;
            4)
                fnVol "4" "Device_3" 
            ;;
            5)
                alsamixer
            ;;
            6)
                break
            ;;
    esac
    done    
;;
4)
    sudo killall screen
    sudo killall player.sh
    cd /home/pi/player-pi/ && ./player.sh >/dev/null & 
;;
5)

    if (whiptail --title "Potwierdz wybor" --yesno "Czy na pewno chcesz wylaczyc dzwieki?." 8 78); then
        sudo killall screen
        sudo killall player.sh
    else
        whiptail --title "Informacja" --msgbox "Anulowales wylaczenie dzwiekow." 8 78
    fi
    
;;
6)
    if [[ $(sudo pgrep player.sh) > 0 ]]; then
        whiptail --title "Informacja" --msgbox "Dzwieki aktualnie dzialaja" 8 78
    else
        cd /home/pi/player-pi/ && ./player.sh >/dev/null &
    fi
;;
7)
    if (whiptail --title "Potwierdz wybor" --yesno "Czy na pewno chcesz zrestartowac." 8 78); then
        sudo reboot now
    
    else
        whiptail --title "Informacja" --msgbox "Anulowales restart Raspberry pi." 8 78
    fi
;;
8)
    checkBashrc=$(grep "@reboot root cd /home/pi/player-pi/ && ./player.sh" /etc/crontab)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        if (whiptail --title "Potwierdz wybor" --yesno "Czy na pewno chcesz wylaczyc dzwieki po starcie systemu." 8 78); then
            sudo sed -e '/^@reboot/d' /etc/crontab >> sudo /etc/crontab
    
        else
            whiptail --title "Informacja" --msgbox "Anulowales chec wylaczenia dzwiekow po starcie systemu." 8 78
        fi
        
    else
        whiptail --title "Informacja" --msgbox "Aktualnie dzwieki sa wylaczone po starcie systemu." 8 78
    fi
;;
9)
    checkBashrc=$(grep "@reboot root cd /home/pi/player-pi/ && ./player.sh" /etc/crontab)
    exitstatus=$?
    
    if [ $exitstatus = 0 ]; then
        echo "Prawdopodobnie player-pi juz uruchamia sie ze startem systemuu"
    else
        sudo echo "@reboot root cd /home/pi/player-pi/ && ./player.sh" >> /etc/crontab
    fi
;;
10)
    break
;;
esac
done
echo "Author: Wojciech Madeja, ver. 1.1"

