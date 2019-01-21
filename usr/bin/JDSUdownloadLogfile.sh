#!/usr/bin/ksh
cm="site"
filename="testid"
output="/tmp/logfile.xml"
# A string with command options
options=$@

# An array with all the arguments
arguments=($options)

# Loop index
index=0

for argument in $options
  do
    # Incrementing index
    index=`expr $index + 1`

    # The conditions
    case $argument in
      -c) cm=${arguments[index]} ;;
      -t) testid=${arguments[index]} ;;
      -o) output=${arguments[index]} ;;
      -h) echo "$0 -c [CTH/FBN/SZ] -t Test ID on TDS -o outputfile by default /tmp/logfile.xml"
	  exit 1;;
    esac
  done
echo CM=$cm Test=$testid output=$output
server="sample"
if [[ $cm = "CTH" ]]; then
	server="pgoracledb1"
elif [[ $cm = "FBN" ]]; then
	server="fnoracledb1"
elif [[ $cm = "SZ" ]]; then
	server="szoracledb1"
fi
#echo $server
wget -O ${output} http://${server}/pls/webstart/pltestdata.gettd?tid=${testid}
exit 0
