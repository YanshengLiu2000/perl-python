#!/bin/sh

for file in $@
do 
	time=`ls -l $file | cut -d" " -f6-8`
	#echo $time
	convert -gravity south -pointsize 36 -draw "text 0,10 '$time'" "$file" "$file"
	
	display "$file"
	

done
