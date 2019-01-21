#!/usr/bin/ksh
ECO=$1
logfile="/export/LogFile/${ECO}.html"
if [[ -e "/export/LogFile/${ECO}.html" ]]; then
	# sed -i '' '/<\/html>/d' $logfile
	# sed -i '' '/<\/body>/d' $logfile
	# echo $(date) >> $logfile
	# echo "This ${ECO} already commit to SVN -> skip it"
	exit 0
elif [[ -e "/export/LogFile/b${ECO}.html" ]]; then
	echo "This ${ECO} in Blocking list"
	exit 0
elif [[ -e "/export/LogFile/b${ECO}" ]]; then
        echo "This ${ECO} in Blocking list"
        exit 0
else
	echo "<html>" > $logfile
	echo "<head><title>${ECO}</title></head>" >> $logfile
	echo "<body>" >> $logfile
	echo "" >> $logfile
	echo "$(date)</br></br>" >> $logfile
fi
loop=0
found=0

SAVEIFS=$IFS
FS=$(echo -en "\n\b")
for folder in $(ls /home/agupdate/${ECO} | grep -v Backup)
do
    folderSearch=/home/agupdate/${ECO}/${folder}/*
    for fileName in $folderSearch
    do
	file=${fileName##*/}
	echo "<p>Looking for SVN path of <strong>${file}</strong></br>" >> $logfile
	filePath=$(/usr/bin/JDSUfindFile.sh "${file}")
	print "<blockquote>" >> $logfile
	eval '/usr/bin/JDSUfindFile.sh "${file}"'
	ret_code=$?
	if [ $ret_code != 0 ]; then
		print "This ${file} is not our target .... Skip it</br>" >> $logfile
	else
	#	zip_check="$(file ${file}|grep Zip)"
	#	if [ "${zip_check#*Zip}" != "$zip_check" ]; then
	#		mv $file tmpzip.zip
	#		unzip -p tmpzip.zip \*.xml | cat > ${file}
	#		rm -rf tmpzip.zip 	
	#	fi
		print "SVN path of ${file} is : <strong>${filePath}</strong></br>" >> $logfile
		# print "Waiting for SVN path to copy to</br>" >> $logfile
		# need to enable when real run
		cp -prf "/home/agupdate/${ECO}/${folder}/${file}" "/Import/FBN/${filePath}"
		cp -prf "/home/agupdate/${ECO}/${folder}/${file}" "/Import/CTH/${filePath}"
		print "copy Agile/${ECO}/${folder}/${file} to FBN/${filePath}<br/>" >> $logfile
		print "copy Agile/${ECO}/${folder}/${file} to CTH/${filePath}<br/>" >> $logfile
		# need to enable when real run
		# print "Remove /home/agupdate/${ECO}/${file}</br>" >> $logfile
		# rm -rf /home/agupdate/${ECO}/${file}
		found=`expr ${found} + 1` 
	fi
	print "</blockquote></p>" >> $logfile
	loop=`expr ${loop} + 1` 
    done
done
IFS=$SAVEIFS
echo "</br></br>Found = ${found}</br>Total Files in ECO = ${loop}</br>" >> $logfile
if [[ ${found} -eq ${loop} ]]; then
	print "All files already submitted to subversion</br>" >> $logfile
	# need to enable when real run
	# rm -rf /home/agupdate/${ECO}
else
	print "Still have some files need to investigate</br>" >> $logfile
fi
# need to enable when real run
echo "<br/>Implement for FBN<br/><blockquote><pre>" >> $logfile
 cd /Import/FBN
 svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
svn commit -m "${ECO}" /Import/FBN >> $logfile
echo "</pre></blockquote>" >> $logfile
echo "<br/>Implement for CTH<br/><blockquote><pre>" >> $logfile
 cd /Import/CTH
 svn status . | grep '?' | sed 's/^?* /svn add "/' | awk '$1=$1' ORS='"\n'|sed 's/" P/"P/' |bash >> $logfile
svn commit -m "${ECO}" /Import/CTH >> $logfile
echo "</pre></blockquote>" >> $logfile
echo "</body>" >> $logfile
echo "</html>" >> $logfile

