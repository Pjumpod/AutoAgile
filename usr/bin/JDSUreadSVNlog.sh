#!/usr/bin/ksh
BU=$1
echo "<html><title>$(date)</title>" > /export/LogFile/HISTORY/${BU}.html
echo "<head><style type=\"text/css\">" >>  /export/LogFile/HISTORY/${BU}.html
echo "table.three{width:100%;border:0;}" >> /export/LogFile/HISTORY/${BU}.html
echo "table.three th { font-weight:bold; border-bottom:1px solid #CCC; border-top:1px solid #CCC; background-color:#F2F9FF ;color:#0000CC;}" >> /export/LogFile/HISTORY/${BU}.html
echo "table.three td { padding:5px; border-bottom:1px dotted #CCC; text-align: center;}" >> /export/LogFile/HISTORY/${BU}.html
echo "</style></head><body>" >> /export/LogFile/HISTORY/${BU}.html
echo "<a href=../TesterList.html>BACK</a></br>"  >> /export/LogFile/HISTORY/${BU}.html
echo "<table class=three cellspacing=\"0\">" >> /export/LogFile/HISTORY/${BU}.html
echo "<tr><th>Tester</th><th>IP Address</th><th>Status</th><th>Last Update</th><th>Revision</th></tr>" >> /export/LogFile/HISTORY/${BU}.html
CTHversion=$( svn info /Import/CTH | grep Revision | awk -F' ' '{print $2}')
FBNversion=$( svn info /Import/FBN | grep Revision | awk -F' ' '{print $2}')
for file in $(ls /export/LogFile/TesterLog/*_${BU}_*)
do
	echo "<tr>" >> /export/LogFile/HISTORY/${BU}.html
	filename=${file##*/}
	echo "<td><a href=./$(echo $filename|awk -F _ '{print $1}').html target='_blank'>$(echo $filename|awk -F _ '{print $1}')</a></td>" >> /export/LogFile/HISTORY/${BU}.html
	echo "<td>$(cat $file| awk 'NR == 1')</td>" >> /export/LogFile/HISTORY/${BU}.html
	echo "<td>" >>  /export/LogFile/HISTORY/${BU}.html
	ipaddress=$(cat $file| awk 'NR == 1')
	ipaddress=$(print "$ipaddress" | nawk '{gsub(/^[ ]*/,"",$0); gsub(/[ ]*$/,"",$0) ; print }')
	if ping -qc1 -W 1 "$ipaddress" > /dev/null ; then
  		echo "<font color=green>PINGABLE</font>"  >>  /export/LogFile/HISTORY/${BU}.html
	else
  		echo "<font color=red>DOWN</font>"  >>  /export/LogFile/HISTORY/${BU}.html
	fi
	echo "<td><a href=../TesterLog/$(echo $filename|awk -F _ '{print $1}')_${BU}_svnlog.txt target='_blank'>$(cat $file| awk 'NR == 2') $(cat $file| awk 'NR == 3')</a></td>" >> /export/LogFile/HISTORY/${BU}.html
	currentVersion=$(tail -1 $file| awk -F'revision ' '{print $2}'| awk -F. '{print $1}')
	substring="cth"
	spaceLimited="5"
	if test "${BU#*$substring}" != "$BU" ; then
		spaces=$((CTHversion-currentVersion))
	else
		spaces=$((FBNversion-currentVersion))
	fi
	if [ $spaces -ge $spaceLimited ]; then
		versionColor=RED
	else
		versionColor=GREEN
	fi
	echo "<td><font color=${versionColor}>${currentVersion}</font></td>" >>  /export/LogFile/HISTORY/${BU}.html
	echo "</tr>" >> /export/LogFile/HISTORY/${BU}.html
	echo "$(echo $filename|awk -F _ '{print $1}'), $(cat $file| awk 'NR == 2') $(cat $file| awk 'NR == 3'), 
		$(tail -1 $file| awk -F' ' '{print $3}'| awk -F. '{print $1}')<br/>" >> /export/LogFile/HISTORY/$(echo $filename|awk -F _ '{print $1}').html
done
echo "</table></body></html>" >> /export/LogFile/HISTORY/${BU}.html

