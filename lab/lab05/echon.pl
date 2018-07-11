#!/usr/local/bin/perl -w

$nargs=@ARGV;

if($nargs!=2){
	die "Usage: ./echon.pl <number of lines> <string>\n";
}
else{
	$times=$ARGV[0];
	$word=$ARGV[1];
	$check=$times;
	$check=~s/[0-9]//g;

	#print "===========>$check\n";

	if(length($check)!=0){
		die "./echon.pl: argument 1 must be a non-negative integer\n";
	}
	else{
		$i=0;
		if($times>$i){
			while($i<$times){
				print "$word\n";
				$i++;
			}
		}
		elsif($times==$i) {exit 0;}
		#elsif($times<$i) {die "argument 1 must be a non-negative integer\n";}
	}
}








