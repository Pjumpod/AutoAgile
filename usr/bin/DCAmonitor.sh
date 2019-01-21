#!/usr/bin/ksh
echo "Starting DCAmonitor $(date)" >> /var/log/DCAmonitor.log
#status=`ps -efww | grep -w "DCAmonitor.sh" | grep -v grep | grep -v $$ | awk '{ print $2 }'`
#if [ ! -z "$status" ]; then
#        echo "[`date`] : DCAmonitor.sh : Process is already running"
#	echo "DCA Process is running $status" >> /var/log/DCAmonitor.log
#        exit 1;
#fi
cd /home/DCA/
timenow=$(date +"%s")
for file in $(ls /home/DCA/ | grep -i gif)
do
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
        if [ ! -d "/home/DCA/${datetmp}" ]
        then
                mkdir /home/DCA/${datetmp}
        fi
	timeLog=$( date -d"${Year}-${Month}-${Day} ${HourMinute} GMT+7" +"%s")
        diff=$(($timenow - $timeLog))
        HourDiff=$(($diff / 3600 ))
        if [ $diff -gt 1800 ]
	then
		identify /home/DCA/${file}
		STATUS="$?"
		if [ "$STATUS" == "0" ]
		then
			gifsicle -O8 --colors=127 --use-col=web /home/DCA/${file} -o /home/DCA/${file}
			echo "move ${datetmp}/${file}"
		else
			echo "just move to ${datetmp}/${file}"
		fi
		mv /home/DCA/${file} /home/DCA/${datetmp}/${file}
	else
		echo "skip $diff ${file}"
	fi
done
timenow=$(date +"%s")
for file in $(ls /home/DCA/ | grep -i jpg)
do
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
        if [ ! -d "/home/DCA/${datetmp}" ]
        then
                mkdir /home/DCA/${datetmp}
        fi
	timeLog=$( date -d"${Year}-${Month}-${Day} ${HourMinute} GMT+7" +"%s")
        diff=$(($timenow - $timeLog))
        HourDiff=$(($diff / 3600 ))
        if [ $diff -gt 1800 ]
        then
		identify /home/DCA/${file}
                STATUS="$?"
                if [ "$STATUS" == "0" ]
                then
			convert /home/DCA/${file} -quality 30% -resize 800x600 /home/DCA/${file}
        		jpegtran -copy none -progressive -optimize /home/DCA/${file} > /tmp/${file}
        		jpegtran -copy none -progressive -optimize /tmp/${file} > /home/DCA/${file}
			rm -rf /tmp/${file}
			echo "move ${datetmp}/${file}"
        	else
			echo "just move ${datetmp}/${file}"
        	fi
        	mv /home/DCA/${file} /home/DCA/${datetmp}/${file}
	else
		echo "skip ${datetmp} $diff ${file}"
	fi
done
#cd /home/DCA
#find . > /home/DCA/database.txt
#zip database.zip database.txt
#rm -rf /home/DCA/database.txt
# not need but I don't want any missing data later.
#cd /JDSU/DCA
#find . > /home/DCA/database2.txt
#cd /home/DCA
#zip database2.zip database2.txt
#rm -rf /home/DCA/database2.txt
echo "END: DCAmonitor $(date)" >> /var/log/DCAmonitor.log
