#!/usr/bin/ksh
csv_input="/home/export/Engineering/2YearsYield/sample.csv"
cm="CTH"
output="/home/export/Engineering/2YearsYield/data.csv"
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
      -i) csv_input=${arguments[index]} ;;
      -o) output=${arguments[index]} ;;
      -h) echo "$0 -c [CTH/FBN/SZ] -t Test ID on TDS -o outputfile by default /tmp/logfile.xml"
	  exit 1;;
    esac
  done
echo "SN,PN,SMSR Min value,SMSR Min channel,SMSR Max value,SMSR Max channel" > ${output}
while IFS= read -r line; do
	#echo "tester: $line"
	testid=$(echo ${line} | awk -F',' '{print $2}')
	#echo $testid
	if [ ${#testid} -gt 5 ]; then
		if [ ${#testid} -lt 12 ]; then
			/usr/bin/JDSUdownloadLogfile.sh -c ${cm} -o "/tmp/logfile.xml" -t ${testid}
			cat /tmp/logfile.xml | grep -v "InstrumentsLib.InstrumentSharing" > /tmp/logfile_real.xml
			/usr/bin/JDSUfindSMSR.sh -i "/tmp/logfile_real.xml" -o ${output}
		fi
	fi
done < "$csv_input"
exit 0
