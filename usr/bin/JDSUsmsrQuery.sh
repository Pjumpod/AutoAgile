#!/usr/bin/ksh
input="/tmp/logfile.xml"
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
commonNode="/Scripts/MeasTxSpectrumScript/TestResults/TxSpectrumMeasurements/BroadbandSmsr_dB/MeasuredData/MeasDatum/Value"
SMSRnode=$(xmlstarlet el -u ${input} |grep ${commonNode})
if [[ $SMSRnode = "" ]]; then
	exit 0
fi
SMSRList=$(xmlstarlet sel -t -v ${SMSRnode} ${input})
if [[ $verbose = "on" ]]; then
	echo $SMSRList
fi 

TesterNameNode="TXfpModuleTestData/ComputerName"
TesterNameList=$(xmlstarlet sel -t -v ${TesterNameNode} ${input})

TosaNode="TXfpModuleTestData/DutInformation/TosaSerialNumber"
TosaNameList=$(xmlstarlet sel -t -v ${TosaNode} ${input})

ChannelListNode=$(echo $SMSRnode | sed "s/$(echo ${commonNode} | sed 's/\//\\\//g')/\/Channels/g")
ChannelLists=$(xmlstarlet sel -t -v ${ChannelListNode} ${input})
ChannelList=$(echo $ChannelLists | awk -F' ' '{print $1}')
#if [[ $verbose = "on" ]]; then
#        echo Channel List=$ChannelList
#fi
FirstChannel=$(echo $ChannelList | awk -F',' '{print $2}')
if [[ $verbose = "on" ]]; then
        echo First Channel = $FirstChannel
fi
LastChannel=$(echo $ChannelList | awk -F',' '{print $3}')
if [[ $verbose = "on" ]]; then
        echo Last Channel = $LastChannel
fi

SerialNumberNode="TXfpModuleTestData/DataSheet/SerialNumber"
SerialNumber=$(xmlstarlet sel -t -v ${SerialNumberNode} ${input})
PartNumberNode="TXfpModuleTestData/DataSheet/ItemNumber"
PartNumber=$(xmlstarlet sel -t -v ${PartNumberNode} ${input})

IFS='\n'
LowestSMSR=$(echo "${SMSRList[*]}" | sort -n | head -n1)
if [[ $verbose = "on" ]]; then
        echo Lowest SMSR = $LowestSMSR
fi
let "n=($(echo ${SMSRList[@]} | tr -s " " "\n" | grep -xn "${LowestSMSR}" | cut -d":" -f 1 |tail -1))"
let "LowestChannel=${n}+${FirstChannel}-1"
if [[ $verbose = "on" ]]; then
        echo Lowest CH = $LowestChannel
fi

IFS='\n'
HighestSMSR=$(echo "${SMSRList[*]}" | sort -nr | head -n1)
if [[ $verbose = "on" ]]; then
        echo Highest SMSR = $HighestSMSR
fi
let "n=($(echo ${SMSRList[@]} | tr -s " " "\n" | grep -xn "${HighestSMSR}" | cut -d":" -f 1 | tail -1))"
let "HighestChannel=${n}+${FirstChannel}-1"
if [[ $verbose = "on" ]]; then
        echo Highest CH = $HighestChannel
fi

SMSRoutput=""
for i in {2..${FirstChannel}}
do
  SMSRoutput=${SMSRoutput}$(echo "-,")
done
SMSRoutput=${SMSRoutput}$(echo ${SMSRList[@]}|tr -s "\n" ",")
if [[ ${LastChannel} -lt 101 ]]; then
	for i in {${LastChannel}..101}
	do
  		SMSRoutput=${SMSRoutput}$(echo "-,")
	done
fi
SMSRoutput=${SMSRoutput}$(echo "-")

echo ${SMSRoutput}

if [[ $HighestChannel -lt 900 ]]; then
	echo ${SerialNumber},${PartNumber},${TosaNameList},${TesterNameList},${FirstChannel},${LastChannel},${LowestSMSR},${LowestChannel},${HighestSMSR},${HighestChannel},${SMSRoutput} >> $output
fi

exit 0
