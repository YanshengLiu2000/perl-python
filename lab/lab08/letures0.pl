#!/usr/bin/perl -w

$aim=$ARGV[0];
$url="http://timetable.unsw.edu.au/2017/$aim.html";
open F,"-|","wget -q -O- $url";

$jump=-1;
$subjump=-1;
while($line=<F>){
	if($jump!=0){
		$jump--;
		next;
	}
	elsif($line=~/<td class="data" colspan="5"><a href="#(.*)S"/){#129
		$semester=$1;		
		print"test=========>$semester\n";
	}
	elsif($line=~/<td class="tableHeading">Day\/Start Time<\/td>/){
		$jump=6;	
	}
	elsif($jump==0){
		if($line=~/Lecture/){
			$subjump=6;
		}
		elsif($subjump!=0){
			$subjump--;
			next;
		}
		else{
			$line=~/<td class="data">(.*)<\/td>/;
			$result=$1;
			print"test=======> $result";
		}	
	}

}

#82 course name
#129 semester
#203(no) Lecture
