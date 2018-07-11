#!/usr/bin/perl -w
#print"$ARGV[0],,,,,,,$ARGV[1]";

$aim=$ARGV[0];
$num=0;
foreach $line (<STDIN>){
	$line=lc $line;
	@words=($line=~/[a-z]+/g);
	foreach $word (@words){
		if($word eq $aim){$num++;}
	}
}

print"$aim occurred $num times\n";
