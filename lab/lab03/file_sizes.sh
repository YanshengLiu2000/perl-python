#!/bin/sh
#set -x

#chmod 755 file_sizes.sh

sf='Small files:'
mf='Medium-sized files:'
lf='Large files:'

for file in *
do
	size=`wc -l $file|cut -d" " -f1`
	#echo $size
	#echo $file
	if [ $size -lt 10 ]
	then
		sf=`echo $sf $file`
	elif [ $size -gt 100 ]
	then
		lf=`echo $lf $file`
	else
		mf=`echo $mf $file`
	fi
done

echo "${sf}"
echo "${mf}"
echo "${lf}"
