#!/usr/bin/ksh
svn update /JDSU/Product
logfile=/export/LogFile/AutoSyncDebugFolder.txt
BU=CTH
echo "------------Current BU = ${BU} -------------"
for product in $(ls /Import/${BU}/Product/ )
do
	if [[ -e "/Import/${BU}/Product/${product}/Script/" ]]; then
                if [[ ! -e "/Import/${BU}/Product/${product}/Script/Debug" ]]; then
                        mkdir /Import/${BU}/Product/${product}/Script/Debug
                fi
		if [[  -e "/JDSU/Product/${product}/Script/Debug" ]]; then
			cp -prf /JDSU/Product/${product}/Script/Debug/* /Import/${BU}/Product/${product}/Script/Debug/
			found=1
		elif [[  -e "/JDSU/Product/${product}/Script/debug" ]]; then
			cp -prf /JDSU/Product/${product}/Script/debug/* /Import/${BU}/Product/${product}/Script/Debug/
			found=1
		else
			echo "${product} does not have Debug folder"
			found=0
		fi
	cd /Import/${BU}/Product/${product}/Script/Debug/
        svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |sed 's/\" /\"/' |bash >> $logfile
        svn commit -m "Sync debug folder" /Import/${BU}/Product/${product}/Script/Debug/ >> $logfile
	fi
done
echo "------------Current BU = ${BU} -------------"
for product in $(ls /Import/${BU}/ProductionScript/ )
do
        if [[ -e "/Import/${BU}/ProductionScript/${product}/Script/" ]]; then
                if [[ ! -e "/Import/${BU}/ProductionScript/${product}/Script/Debug" ]]; then
                        mkdir /Import/${BU}/ProductionScript/${product}/Script/Debug
                fi
                if [[  -e "/JDSU/Product/${product}/Script/Debug" ]]; then
                        cp -prf /JDSU/Product/${product}/Script/Debug/* /Import/${BU}/ProductionScript/${product}/Script/Debug/
                        found=1
                elif [[  -e "/JDSU/Product/${product}/Script/debug" ]]; then
                        cp -prf /JDSU/Product/${product}/Script/debug/* /Import/${BU}/ProductionScript/${product}/Script/Debug/
                        found=1
                else
                        echo "${product} missing Debug folder"
                        found=0
                fi
        cd /Import/${BU}/ProductionScript/${product}/Script/Debug/
        svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |sed 's/\" /\"/'| bash >> $logfile
        svn commit -m "Sync debug folder" /Import/${BU}/ProductionScript/${product}/Script/Debug/ >> $logfile
        fi
done
BU=FBN
echo "------------Current BU = ${BU} -------------"
for product in $(ls /Import/${BU}/Product/ )
do
        if [[ -e "/Import/${BU}/Product/${product}/Script/" ]]; then
                if [[ ! -e "/Import/${BU}/Product/${product}/Script/Debug" ]]; then
                        mkdir /Import/${BU}/Product/${product}/Script/Debug
                fi
                if [[  -e "/JDSU/Product/${product}/Script/Debug" ]]; then
                        cp -prf /JDSU/Product/${product}/Script/Debug/* /Import/${BU}/Product/${product}/Script/Debug/
                        found=1
                elif [[  -e "/JDSU/Product/${product}/Script/debug" ]]; then
                        cp -prf /JDSU/Product/${product}/Script/debug/* /Import/${BU}/Product/${product}/Script/Debug/
                        found=1
                else
                        echo "${product} missing Debug folder"
                        found=0
                fi
        cd /Import/${BU}/Product/${product}/Script/Debug/
        svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |sed 's/\" /\"/'| bash >> $logfile
        svn commit -m "Sync debug folder" /Import/${BU}/Product/${product}/Script/Debug/ >> $logfile
        fi
done

#cd /Import/FBN
# svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
# svn commit -m "Sync debug folder" /Import/FBN >> $logfile
#cd /Import/CTH
# svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
# svn commit -m "sync debug folder" /Import/CTH >> $logfile
