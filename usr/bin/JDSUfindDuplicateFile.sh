#!/usr/bin/ksh
file=$1
#if [[ -e "/JDSU/Product/TXfp/Script/${file}" ]]; then
#    	echo "/JDSU/Product/TXfp/Script/${file} exist"
#else
#	echo "/JDSU/Product/TXfp/Script/${file} does not exist"
#fi
path="/JDSU/Product/"
for file in $(ls $path/TXfp/Firmware)
do
        if [[ -e "$path/TSfp/Firmware/${file}" ]]; then
                echo "Firmware/${file}";
                found=1;
	fi
done
for file in $(ls $path/TXfp/EEPROM)
do
        if [[ -e "$path/TSfp/EEPROM/${file}" ]]; then
                echo "EEPROM/${file}";
                found=1;
	fi
done
for file in $(ls $path/TXfp/Script)
do
        if [[ -e "$path/TSfp/Script/${file}" ]]; then
                echo "Script/${file}";
                found=1;
	fi
done
