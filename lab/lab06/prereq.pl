#!/usr/bin/perl -w
$key=$ARGV[0];
#if($key=~/[A-Z]{4}9/){
#	$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/current/$key.html";
#}else{
#	$url = "http://www.handbook.unsw.edu.au/undergraduate/courses/current/$key.html";
#}
$url = "http://www.handbook.unsw.edu.au/undergraduate/courses/current/$key.html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	if ($line =~/Prerequisite/){
		#print "This is the line:  $line\n";
		#$line =~"Prerequisite:(.*)</p><p><strong>Excluded";
		$line =~"Prerequisit(.+?)<";
		$course=$1;
		#print "=========>$course \n";
		$course=~s/\s//g;
		#print "=========>$course \n";
		$course=~s/^.*://;
		$or="or";
		$really="amarkofatleast75ineither";
		if($course=~/$really/){
			$course=~s/amarkofatleast75ineither//;
			$course=~s/.$//;
		}
		if ($course=~/$or/){
			#$course=~tr/or/\n/;
			@results=split(/or/,$course);
			foreach $key (@results){
				print "$key\n";
			}
			last;
		}else{
			print "$course\n";
			last;
		}
		
	}
}

$url = "http://www.handbook.unsw.edu.au/postgraduate/courses/current/$key.html";
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	if ($line =~/Prerequisite/){
		#print "This is the line:  $line\n";
		#$line =~"Prerequisite:(.*)</p><p><strong>Excluded";
		$line =~"Prerequisit(.+?)<";
		$course=$1;
		#print "=========>$course \n";
		$course=~s/\s//g;
		#print "=========>$course \n";
		$course=~s/^.*://;
		$or="or";
		$really="amarkofatleast75ineither";
		if($course=~/$really/){
			$course=~s/amarkofatleast75ineither//;
			$course=~s/.$//;
		}
		if ($course=~/$or/){
			#$course=~tr/or/\n/;
			@results=split(/or/,$course);
			foreach $key (@results){
				print "$key\n";
			}
			last;
		}else{
			print "$course\n";
			last;
		}
		
	}
}
