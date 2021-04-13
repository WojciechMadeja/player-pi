#!/bin/bash

fnCheck() {
	du -s $1
}

echo "$checkDirectory"
while true
do
	checkDirectory=$(find /media/pi -type d -name 'Enter' 2> /dev/null)


	if [[  $checkDirectory > 0 ]]; then
		echo "Jest katalog"
		checkSize=$( fnCheck "$checkDirectory"| awk '{print $1}' )
		echo "$checkSize"
		checkSize2=$( du -s /home/pi/player-pi/video-pi/pictures | awk '{print $1}' )
		echo "$checkSize2"
		if [[ $checkSize == $checkSize2 ]]; then
			echo "Pliki już skopiowane"
		else
			echo "Kopiuję"
			cp $checkDirectory/* /home/pi/player-pi/video-pi/pictures
			photofilmstrip-cli --f 6 -t 25 -p  /home/pi/player-pi/video-pi/video/video.pfs -o /home/pi/player-pi/video-pi/video
			cp /home/pi/player-pi/video-pi/video/HD\ 1080p@60.00\ fps/video.mp4 /home/pi/player-pi/video-pi/play
			# sudo reboot now
			echo "Gotowe"
		fi		
	else
		true
	fi
done
# find /media/pi -type d -name 'Enter' 2> /dev/null


# cp -F /home/katalog1/* /home/katalog2

# photofilmstrip-cli --f 6 -t 25 -p  /home/pi/Desktop/test.pfs -o home/pi/Desktop
