#!/usr/bin/perl -w

foreach $line (<STDIN>){
	my($num, $whale)=$line=~/(\d+) (.*)/;
	$whale=~s/^ *//;
	$whale=~s/ *$//;
	$whale=~tr/[A-Z]/[a-z]/;
	$whale=~s/s$//;
	$whale=~s/\s+/ /g;
	#print"====> $num ====>> $whale  \n";
	$book{$whale}{"num"}+=$num;
	$book{$whale}{"pod"}+=1;
		
}

for $key (sort keys %book){
	#print "$key\n";
	#print "$book{$key}{'pod'}";
	print "$key observations: $book{$key}{'pod'} pods, $book{$key}{'num'} individuals\n";
}
