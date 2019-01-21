#!/usr/bin/ksh
input="/tmp/logfile_64000318FBN_real.xml"
output="/tmp/data.csv"
verbose="off"
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
      -i) input=${arguments[index]} ;;
      -o) output=${arguments[index]} ;;
      -v) verbose="on" ;;
      -h) echo "$0 -i input file by default /tmp/logfile.xml"
	  exit 1;;
    esac
  done
#server="sample"
#if [[ $cm = "CTH" ]]; then
#	server="pgoracledb1"
#elif [[ $cm = "FBN" ]]; then
#	server="fnoracledb1"
#elif [[ $cm = "SZ" ]]; then
#	server="szoracledb1"
#fi
#wget -O ${output} http://${server}/pls/webstart/pltestdata.gettd?tid=${testid}
commonNode="Scripts/ContainerScript/Scripts/InstrumentCalScript/TestResults/CalibrationData/InstrumentCalConfigDatum"
data=$(xmlstarlet el -u ${input} |grep ${commonNode})
if [[ $data = "" ]]; then
	exit 0
fi
echo $data
exit 0
