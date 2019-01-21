#!/usr/bin/ksh
IFS=$'\n'
find /home/agupdate > /tmp/agile.txt
for file in $(cat /tmp/agile.txt | grep zip)
do
        rm -v --  "${file}"
done
for file in $(cat /tmp/agile.txt | grep exe)
do
	rm -v -- "${file}"
done
