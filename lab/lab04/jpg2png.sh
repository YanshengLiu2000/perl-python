#!/bin/sh

chmod 755 jpg2png.sh
#set -x
for file in *
do
#	echo "$file"
	check=`echo $file | cut -d "." -f2`
	#echo "|$check|"
	jpg="jpg"
	if test $check = $jpg
	then
 
		if test -e "${file%.*}.png"
		then
			echo "${file%.*}.png already exists"
			exit 0
		else
			convert "$file" "${file%.*}.png" #2>/dev/null
			#echo "|Convert Complete!|"
			rm "$file"
		fi
	fi
done
