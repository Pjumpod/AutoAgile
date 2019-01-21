#!/usr/bin/ksh
svn update /JDSU/CommandMap/
logfile=/export/LogFile/AutoSyncDebugFolder.txt
cp -prf /JDSU/CommandMap/* /Import/CTH/CommandMap/
cd /Import/CTH/CommandMap/
svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |sed 's/\" /\"/'| bash 
svn commit -m "Update CommandMap" /Import/CTH/CommandMap/

cp -prf /JDSU/CommandMap/* /Import/FBN/CommandMap/
cd /Import/FBN/CommandMap/
svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |sed 's/\" /\"/'| bash
svn commit -m "Update CommandMap" /Import/FBN/CommandMap/

#cd /Import/FBN
# svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
# svn commit -m "Sync debug folder" /Import/FBN >> $logfile
#cd /Import/CTH
# svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
# svn commit -m "sync debug folder" /Import/CTH >> $logfile
