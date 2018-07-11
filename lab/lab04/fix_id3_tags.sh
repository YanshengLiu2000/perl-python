#!/bin/sh

album=`echo $1|cut -d "/" -f2`
year=`echo $1 | cut -d "," -f2 | sed 's/^ //'`

#echo "|$album|"
#echo "|$year|"
#echo "|$track|"

#for file in "$1"/*.mp3
#do
#	title=`echo $file | cut -d "-" -f2 | sed 's/^ //;s/ $//'`
#	echo "|$title|"
#done

for file in "$1"/*.mp3
do
#	echo "${file}:"
	track=`echo $file | cut -d "/" -f3 | cut -d "-" -f1| sed 's/ $//' `
#	echo "The Track is |$track|"
	artist=`echo $file | cut -d "-" -f3 |cut -d "." -f1 | sed 's/^ //'`
#	echo "Artist |$artist|"
	title=`echo $file | cut -d "-" -f2 | sed 's/^ //;s/ $//'`
#	echo "Title |$title|"
	id3 -t "$title" -T "$track" -a "$artist" -A "$album" -y "$year" "$file" > /dev/null
done
#-T "$track"
