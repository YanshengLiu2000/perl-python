#!/usr/bin/perl -w

$aim=$ARGV[0];
$url="http://timetable.unsw.edu.au/2017/${aim}KENS.html";
open F,"-|","wget -q -O- $url";

while($line=<F>){
	#print"test!!!";
	if($line=~/$aim/){
		#print"$line";
		$line =~ /($aim[0-9]{4})/;
		$result = $1;
		#$resut=$0;
		$book{$result}=1;
	}
}
foreach $result (sort keys %book){
	print"$result\n";
}
