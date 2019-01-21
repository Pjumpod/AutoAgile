#!/usr/bin/ksh
cd /home/DCA/
find 2016* > /tmp/DCAtmp
for file in $(cat /tmp/DCAtmp | grep -i gif)
do
	datetime=$(echo $file | awk -F"/" '{print $1}')
	echo "move ${datetime} $file"
	if [ ! -d "/JDSU/DCA/${datetime}" ]
        then
                mkdir /JDSU/DCA/${datetime}
        fi
        mv ${file} /JDSU/DCA/${file}
done

for file in $(cat /tmp/DCAtmp | grep -i jpg)
do
        datetime=$(echo $file | awk -F"/" '{print $1}')
	echo "move ${datetime} $file"
        if [ ! -d "/JDSU/DCA/${datetime}" ]
        then
                mkdir /JDSU/DCA/${datetime}
        fi
        convert ${file} -resize 800x600 /JDSU/DCA/${file}
	rm -rf ${file}
done

find 2017* > /tmp/DCAtmp

for file in $(cat /tmp/DCAtmp | grep -i jpg)
do
        datetime=$(echo $file | awk -F"/" '{print $1}')
	echo "move ${datetime} $file"
        if [ ! -d "/JDSU/DCA/${datetime}" ]
        then
                mkdir /JDSU/DCA/${datetime}
        fi
	convert ${file} -resize 800x600 /JDSU/DCA/${file}
        rm -rf ${file}
done

for file in $(cat /tmp/DCAtmp | grep -i gif)
do
        datetime=$(echo $file | awk -F"/" '{print $1}')
	echo "move ${datetime} $file"
        if [ ! -d "/JDSU/DCA/${datetime}" ]
        then
                mkdir /JDSU/DCA/${datetime}
        fi
        mv ${file} /JDSU/DCA/${file}
done

#find . -type d -empty -delete
echo "$(date) TempMove: Make K9 db" >> /var/log/DCAmonitor.log
rm -rf /tmp/DCAtmp
cd /home/DCAK9
find . -type d -empty | xargs rmdir
find . > /home/DCAK9/databaseK9.txt
zip databaseK9.zip databaseK9.txt
rm -rf /home/DCAK9/databaseK9.txt
echo "$(date) TempMove: Done K9 db" >> /var/log/DCAmonitor.log
echo "$(date) TempMove: Make CM db" >> /var/log/DCAmonitor.log
cd /home/DCA
find . -type d -empty | xargs rmdir
find . > /home/DCA/database.txt
zip database.zip database.txt
rm -rf /home/DCA/database.txt
echo "$(date) TempMove: Done CM db" >> /var/log/DCAmonitor.log
# not need but I don't want any missing data later.
echo "$(date) TempMove: Make backup db" >> /var/log/DCAmonitor.log
cd /JDSU/DCA
find . -type d -empty | xargs rmdir
find . > /home/DCA/database2.txt
cd /home/DCA
zip database2.zip database2.txt
rm -rf /home/DCA/database2.txt
echo "$(date) TempMove: Done backup db" >> /var/log/DCAmonitor.log
