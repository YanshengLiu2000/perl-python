#!/usr/local/bin/perl -w


####This is the perl tail.pl <t1.txt
sub sb1{
	$num_to_print=9;
	while(@line=<STDIN>){
		if($#line>=9){
			$real_start_point=$#line-$num_to_print;
			foreach($real_start_point..$#line){
				chomp $line[$_];
				print "$line[$_]\n";
			}
		}
		else{
			foreach(0..$#line){
				print "$line[$_]\n";
			}
		}
	}

}

#############This is MAIN################

if($#ARGV<0){####This is the perl tail.pl <t1.txt
	$num_to_print=9;
	while(@line=<STDIN>){
		if($#line>=9){
			$real_start_point=$#line-$num_to_print;
			foreach($real_start_point..$#line){
				chomp $line[$_];
				print "$line[$_]\n";
			}
		}
		else{
			foreach(0..$#line){
				print "$line[$_]\n";
			}
		}
	}
}#########
elsif($#ARGV==0){#######This is perl tail.pl t1.txt
	#print "This is perl tail.pl t1.txt \n";
	$num_to_print=9;
	open $input,'<',$ARGV[0] or die "./tail.pl: can't open tX.txt";
	while(@line=<$input>){
		if($#line>=9){
			$real_start_point=$#line-$num_to_print;
			foreach($real_start_point..$#line){
				chomp $line[$_];
				print "$line[$_]\n";
			}
			
		}
		else{
			foreach(0..$#line){
				chomp $line[$_];
				print "$line[$_]\n";
			}
		}
	}
}########
elsif ($#ARGV==1){#######This is perl tail.pl -5 t1.txt
	$num_to_print=$ARGV[0];
	$num_to_print=$num_to_print*-1-1;
	open $input,'<',$ARGV[1] or die "./tail.pl: can't open tX.txt";
	while(@line=<$input>){
		if($#line>=$num_to_print){
			$real_start_point=$#line-$num_to_print;
			foreach($real_start_point..$#line){
				chomp $line[$_];
				print "$line[$_]\n";
			}
			
		}
		else{
			foreach(0..$#line){
				print "$line[$_]\n";
			}
		}
	}
}########
elsif ($#ARGV>1){#######This is perl tail.pl -5 t1.txt t2.txt t3.txt
	$num_to_print=$ARGV[0]*-1-1;
	shift @ARGV;
	foreach $file (@ARGV){
		print "==> $file <==\n";
		open $input,'<',$file or die "./tail.pl: can't open tX.txt";
		while(@line=<$input>){
			if($#line>=$num_to_print){
				$real_start_point=$#line-$num_to_print;
				foreach($real_start_point..$#line){
					chomp $line[$_];
					print "$line[$_]\n";
				}
				
			}
			else{
				foreach(0..$#line){
					chomp $line[$_];
					print "$line[$_]\n";
				}
			}
		}
	}
}########
else{
	print "$#ARGV";
}

