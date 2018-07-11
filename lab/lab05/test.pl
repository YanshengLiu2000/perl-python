#!/usr/local/bin/perl -w

@t= (1, 2, 3, 4, 5);
$i= splice(@t, 0, 1);
print "==@t\n";
print "======$i\n";

if (length(@ARGV)==1 && @ARGV[0]=~'<'){
	print "1111111111111111";
}
else{
	print "222222222";
}

