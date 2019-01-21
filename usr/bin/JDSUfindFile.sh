#!/usr/bin/ksh
file=$1
#if [[ -e "/JDSU/Product/TXfp/Script/${file}" ]]; then
#    	echo "/JDSU/Product/TXfp/Script/${file} exist"
#else
#	echo "/JDSU/Product/TXfp/Script/${file} does not exist"
#fi

for folder in $(ls /JDSU/Product/)
do
        #print "Full file path  in /JDSP dir : $folder"
	if [[ -e "/Import/FBN/Product/${folder}/Script/${file}" ]]; then
                echo "Product/${folder}/Script/${file}";
                found=1;
                break;
	elif [[ -e "/Import/FBN/Product/${folder}/EEPROM/${file}" ]]; then
                echo "Product/${folder}/EEPROM/${file}";
                found=1;
                break;
	elif [[ -e "/Import/FBN/Product/${folder}/Firmware/${file}" ]]; then
                echo "Product/${folder}/Firmware/${file}";
                found=1;
                break;
	elif [[ -e "/Import/FBN/Product/${folder}/Recipt/${file}" ]]; then
                echo "Product/${folder}/Recipt/${file}";
                found=1;
                break;
	elif [[ -e "/Import/FBN/Product/${folder}/Specifications/${file}" ]]; then
                echo "Product/${folder}/Specifications/${file}";
                found=1;
                break;
	elif [[ -e "/Import/FBN/Product/${folder}/TlaFirmware/${file}" ]]; then
                echo "Product/${folder}/TlaFirmware/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/Product/${folder}/Script/${file}" ]]; then
                echo "Product/${folder}/Script/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/Product/${folder}/EEPROM/${file}" ]]; then
                echo "Product/${folder}/EEPROM/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/${folder}/Firmware/${file}" ]]; then
                echo "Product/${folder}/Firmware/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/Product/${folder}/Recipt/${file}" ]]; then
                echo "Product/${folder}/Recipt/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/Product/${folder}/Specifications/${file}" ]]; then
                echo "Product/${folder}/Specifications/${file}";
                found=1;
                break;
        elif [[ -e "/Import/CTH/Product/${folder}/TlaFirmware/${file}" ]]; then
                echo "Product/${folder}/TlaFirmware/${file}";
                found=1;
                break;
	elif [[ -e "/JDSU/Product/${folder}/Script/${file}" ]]; then
		echo "Product/${folder}/Script/${file}";
		found=1;
		break;
	elif [[ -e "/JDSU/Product/${folder}/EEPROM/${file}" ]]; then
		echo "Product/${folder}/EEPROM/${file}";
		found=1;
		break;
        elif [[ -e "/JDSU/Product/${folder}/eeprom/${file}" ]]; then
                echo "Product/${folder}/EEPROM/${file}";
                found=1;
                break;
        elif [[ -e "/JDSU/Product/${folder}/Eeprom/${file}" ]]; then
                echo "Product/${folder}/EEPROM/${file}";
                found=1;
                break;
	elif [[ -e "/JDSU/Product/${folder}/Firmware/${file}" ]]; then
		echo "Product/${folder}/Firmware/${file}";
		found=1;
		break;
	elif [[ -e "/JDSU/Product/${folder}/Script/Debug/${file}" ]]; then
                echo "Product/${folder}/Script/${file}";
                found=1;
                break;
	elif [[ -e "/JDSU/Product/${folder}/Script/Debug_Gen3/${file}" ]]; then
                echo "Product/${folder}/Script/${file}";
                found=1;
                break;
	elif [[ -e "/JDSU/Product/${folder}/Script/Reliability/${file}" ]]; then
                echo "Product/${folder}/Script/Reliability/${file}";
                found=1;
                break;
	elif [[ -e "/JDSU/Product/${folder}/Script/debug/${file}" ]]; then
                echo "Product/${folder}/Script/${file}";
                found=1;
                break;
	elif [[ ${file} = "22113906_RecipeLookupTable.xml" ]]; then
		echo "Product/ITLA/Recipt/RecipeLookupTable.xml";
		found=1;
		break;
        elif [[ ${file} = "22113908_SpecificationLookupTable.xml" ]]; then
                echo "Product/ITLA/Recipt/SpecificationLookupTable.xml";
                found=1;
                break;
	fi
done
if [[ found -eq 1 ]]; then
	exit 0;
else
	echo "File not found in SVN";
	exit 1;
fi
