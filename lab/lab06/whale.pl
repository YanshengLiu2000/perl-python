#!/usr/bin/perl -w

foreach $line (<STDIN>){
	my($num, $whale)=$line=~/(\d+) (.*)/;
	$whale=~s/^ *//;
	$whale=~s/ *$//;
	$whale=~tr/[A-Z]/[a-z]/;
	$whale=~s/s$//;
	$whale=~s/\s+/ /g;
	$book{$whale}{"num"}+=$num;#> /dev/null
	$book{$whale}{"pod"}+=1;
		
}

$key=$ARGV[0];
if (defined $book{$key}){
	print "$key observations: $book{$key}{'pod'} pods, $book{$key}{'num'} individuals\n";
}else{
	print "$key observations: 0 pods, 0 individuals\n";
}	
#print "$key\n";

