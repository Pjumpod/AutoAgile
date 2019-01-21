#!/usr/bin/ksh
for file in $(find . | grep -i gif)
do
        #mv ${file} ../
        datetmp=$(echo ${file}|awk -F 'Time' '{print $2}' | awk -F 'T' '{print $1}')
        Year=$(echo ${datetmp}|awk -F '-' '{print $1}')
        Month=$(echo ${datetmp}|awk -F '-' '{print $2}')
        Day=$(echo ${datetmp}|awk -F '-' '{print $3}')
        if [ "$Year" -gt "2500" ]
        then
                Year=$((Year - 543))
                datetmp=$Year-$Month-$Day
        fi
        if [ ! -d "/home/DCA/${datetmp}" ]
        then
                mkdir /home/DCA/${datetmp}
        fi
	echo Copying $(pwd) ${datetmp} $file
	gifsicle -O8 --colors=127 --use-col=web ${file} -o /home/DCA/${datetmp}/${file}
	rm -rf ${file}
done
for file in $(find . | grep -i jpg)
do
	#mv ${file} ../
	datetmp=$(echo ${file}|awk -F 'Time' '{print $2}' | awk -F 'T' '{print $1}')
        Year=$(echo ${datetmp}|awk -F '-' '{print $1}')
        Month=$(echo ${datetmp}|awk -F '-' '{print $2}')
        Day=$(echo ${datetmp}|awk -F '-' '{print $3}')
        if [ "$Year" -gt "2500" ]
        then
                Year=$((Year - 543))
                datetmp=$Year-$Month-$Day
        fi
        if [ ! -d "/home/DCA/${datetmp}" ]
        then
                mkdir /home/DCA/${datetmp}
        fi
	echo Copying $(pwd) ${datetmp} $file
        convert ${file} -quality 30% -resize 800x600 ${file}
        jpegtran -copy none -progressive -optimize ${file} > /home/DCA/${datetmp}/${file}
	rm -rf ${file}
done
