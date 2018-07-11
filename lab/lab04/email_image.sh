#!/bin/sh

for file in $@
do 
	display $file
	echo "Address to e-mail this image to?"
	read email
	echo "Message to accompany image?"
	read msg
	echo "$msg"|mutt -s "$msg" -e "set copy=no" -a "$file" -- $email
	
done

