#!/usr/bin/perl -w

foreach $line (<STDIN>){
	$line=lc $line;
	@words=($line=~/[a-z]+/g);
	$num+=$#words+1
}

print"$num words\n";
