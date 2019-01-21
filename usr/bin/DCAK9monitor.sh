#!/usr/bin/ksh
echo "Starting DCAK9monitor $(date)" >> /var/log/DCAmonitor.log
#status=`ps -efww | grep -w "DCAK9monitor.sh" | grep -v grep | grep -v $$ | awk '{ print $2 }'`
#if [ ! -z "$status" ]; then
#        echo "[`date`] : DCAK9monitor.sh : Process is already running"
#	echo "DCAK9 Process is running $status" >> /var/log/DCAmonitor.log
#        exit 1;
#fi
if mount | grep /mnt/PlugK9 > /dev/null; then
    	echo "Mounted path"
else
    	echo "Not mount yet, mounting"
	mount /mnt/PlugK9
fi
cd /mnt/PlugK9/
find . > /home/DCAK9/external.txt
cd /home/DCAK9/
timenow=$(date +"%s")
for file in $(cat /home/DCAK9/external.txt | grep -i jpg)
do
	#echo "Working on $file"
	file=$(echo ${file}|awk -F '/' '{print $2}')
	datetmp=$(echo ${file}|awk -F 'Time' '{print $2}' | awk -F 'T' '{print $1}')
        if [ ${#datetmp} -gt 3 ]
        then
	Year=$(echo ${datetmp}|awk -F '-' '{print $1}')
	Month=$(echo ${datetmp}|awk -F '-' '{print $2}')
	Day=$(echo ${datetmp}|awk -F '-' '{print $3}')
	HourMinute=$(echo ${file}|awk -F "$Year-$Month-$Day" '{print $2}' | awk -F 'T' '{print $2}' | awk -F '.' '{print $1}')
	else
        datetmp=$(echo ${file}|awk -F '_' '{print $2}' )
	tmpYear=$(echo $datetmp | cut -c1-2 )
        if [ "$tmpYear" -gt "50" ]
        then
                Year='25'${tmpYear}
        else
                Year='20'${tmpYear}
        fi
        #Year='20'$(echo $datetmp | cut -c1-2 )
        Month=$(echo ${datetmp}| cut -c3-4 )
        Day=$(echo ${datetmp}| cut -c5-6 )
        datetmp=$Year-$Month-$Day
        #echo $file $Year-$Month-$Day
        HourMinute=$(echo ${file}|awk -F '_' '{print $3$4}' )
	fi
	if [ "$Year" -gt "2500" ]
	then
		Year=$((Year - 543))
		datetmp=$Year-$Month-$Day
	fi
	if [ ! -d "/home/DCAK9/${datetmp}" ]
	then
		mkdir /home/DCAK9/${datetmp}
	fi
        timeLog=$( date -d"${Year}-${Month}-${Day} ${HourMinute} GMT+7" +"%s")
        diff=$(($timenow - $timeLog))
        HourDiff=$(($diff / 3600 ))
	if [ $diff -gt 14400 ]  
	then 
		echo "move ${datetmp} ${HourDiff}(${diff})Hours ${file}"
		convert /mnt/PlugK9/${file} -quality 30% -resize 800x600 /home/DCAK9/${datetmp}/${file}
		jpegtran -copy none -progressive -optimize /home/DCAK9/${datetmp}/${file} > /tmp/${file}
                jpegtran -copy none -progressive -optimize /tmp/${file} > /home/DCAK9/${datetmp}/${file}
		rm -rf /tmp/${file}
		rm -rf /mnt/PlugK9/${file}
	else
		echo "not move (${diff}) ${HourDiff} ${file}"
	fi
done
for file in $(cat /home/DCAK9/external.txt | grep -i gif)
do
        #echo "Working on $file"
        file=$(echo ${file}|awk -F '/' '{print $2}')
        datetmp=$(echo ${file}|awk -F 'Time' '{print $2}' | awk -F 'T' '{print $1}')
        if [ ${#datetmp} -gt 3 ]
        then
        Year=$(echo ${datetmp}|awk -F '-' '{print $1}')
        Month=$(echo ${datetmp}|awk -F '-' '{print $2}')
        Day=$(echo ${datetmp}|awk -F '-' '{print $3}')
        HourMinute=$(echo ${file}|awk -F "$Year-$Month-$Day" '{print $2}' | awk -F 'T' '{print $2}' | awk -F '.' '{print $1}')
	else
        datetmp=$(echo ${file}|awk -F '_' '{print $2}' )
	tmpYear=$(echo $datetmp | cut -c1-2 )
        if [ "$tmpYear" -gt "50" ]
        then
                Year='25'${tmpYear}
        else
                Year='20'${tmpYear}
        fi
        #Year='20'$(echo $datetmp | cut -c1-2 )
        Month=$(echo ${datetmp}| cut -c3-4 )
        Day=$(echo ${datetmp}| cut -c5-6 )
        datetmp=$Year-$Month-$Day
        #echo $file $Year-$Month-$Day
        HourMinute=$(echo ${file}|awk -F '_' '{print $3$4}' )
        fi
        if [ "$Year" -gt "2500" ]
        then
                Year=$((Year - 543))
                datetmp=$Year-$Month-$Day
        fi
        if [ ! -d "/home/DCAK9/${datetmp}" ]
        then
                mkdir /home/DCAK9/${datetmp}
        fi
        timeLog=$( date -d"${Year}-${Month}-${Day} ${HourMinute} GMT+7" +"%s")
        diff=$(($timenow - $timeLog))
        HourDiff=$(($diff / 3600 ))
        if [ $diff -gt 14400 ]
        then
                echo "move ${datetmp} ${HourDiff}(${diff})Hours ${file}"
                convert /mnt/PlugK9/${file} -quality 30% /tmp/${file}
		gifsicle -O8 --colors=127 --use-col=web /tmp/${file} -o /home/DCAK9/${datetmp}/${file}
		rm -rf /tmp/${file}
		rm -rf /mnt/PlugK9/${file}
        else
                echo "not move (${diff}) ${HourDiff} ${file}"
        fi
done
#cd /home/DCAK9
#find . > /home/DCAK9/databaseK9.txt
#zip databaseK9.zip databaseK9.txt
#rm -rf /home/DCA/databaseK9.txt
#cd /JDSU/DCA
#find . > /home/DCA/database2.txt
#cd /home/DCA
#zip database2.zip database2.txt
#rm -rf /home/DCA/database2.txt
umount /mnt/PlugK9
echo "END: DCAK9monitor $(date)" >> /var/log/DCAmonitor.log
