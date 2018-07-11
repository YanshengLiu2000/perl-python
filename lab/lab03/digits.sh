#!/bin/sh

#set -x

chmod 755 digits.sh

while read line
do
	output=`echo $line | tr '0-4' '<' | tr '6-9' '>'`
	echo $output
done
