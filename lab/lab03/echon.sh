#!/bin/sh
#set -x
if [ $1 -z ] 2>/dev/null
then
	echo "Usage: ./echon.sh <number of lines> <string>"
	exit 1
else
	if [ $3 -z ] 2>/dev/null
	then
		z=`echo "$1" | egrep '^[0-9]+$'`
		if [ $z -z ] 2>/dev/null
		then 
			echo "./echon.sh: argument 1 must be a non-negative integer"
			exit 1
		else
			while [[ $z > 0 ]]
			do
				z=$(( $z-1 ))
				echo $2
			done
		fi
		exit 0
	else
		echo "Usage: ./echon.sh <number of lines> <string>"
		exit 1
	fi
fi
