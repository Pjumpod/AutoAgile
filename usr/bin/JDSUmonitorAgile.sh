#!/usr/bin/ksh
svn update /JDSU/Product
echo $(date) > /export/LogFile/lastsync
for ECO in $(ls /home/agupdate/ | grep -v Backup)
do
	/usr/bin/JDSUecoManage.sh ${ECO}
done

