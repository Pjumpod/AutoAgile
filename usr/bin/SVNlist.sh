#!/usr/bin/ksh
PATH=/Import/CTH/Product/TXfp/Script
cd $PATH
for single_file in $(/usr/bin/svn list )
do
	if [[ $single_file == *"xml"* ]]; then
		changed=$(/usr/bin/svn log -l1 $single_file | /bin/sed -n -e 4p)
		echo $single_file, $changed
	fi
done

