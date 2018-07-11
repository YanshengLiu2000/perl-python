#!/usr/bin/perl -w


open $input,'<',$ARGV[0] or die;
$line_num=0;
#$ARGV[0]=~/^(.*)\./;
#$new_file_name="$1.pl";
foreach $line (<$input>){

#$line='    b=$a';########################################################
#while($line ne ""){######################################################

	$file{$line_num}="";
	chomp $line;
	#lc $line;
	$line=~/^(\s*)[a-z]/;
	$space=$1;
	#print"test====line===>$line\n";
	#print"TEST Space====>|$space|\n";
	$line=~s/\s+//;
	#print"TEST====>$line\n";
	if($line=~/^#!/){
		$file{$line_num}="#!/usr/bin/perl -w\n";
	#	print"#! find!";
	#	print"====|$file{$line_num}";
	}
	elsif($line=~/^#[^!]/){
		$file{$line_num}=$line.";\n";#> /dev/null
	#	print"comments========\n";
	}
	elsif($line=~/([a-z|A-Z]+) ?= ?([-+]?[0-9]*\.?[0-9]+)/){
		$var=$1;
		$value=$2;
	#	$variable{$var}=1;
		$file{$line_num}="\$$var=$value;\n";
	#	print"====|$file{$line_num}";
	}
	elsif($line=~/while\s?\(\((.*)\)\)/){
		$line=~s/\s+//g;
		$line=~/while\(\((.*)\)\)/;
		$catch=$1;
	#	print"WHILE TEST!=====>|$catch|\n";
		$catch=~/([a-z|0-9]+)([^a-z0-9]*)([a-z|0-9]+)/;
		$var1=$1;
		$sign=$2;
		$var2=$3;
		if($var1=~/^\d+.?\d*$/){
		#	print"This is a var |$add_var|\n";
		}else{
			$var1="\$$var1";
		}

		if($var2=~/^\d+.?\d*$/){
		#	print"This is a var |$add_var|\n";
		}else{
			$var2="\$$var2";
		}
		#print"TEST==>$var1\n";
		#print"TEST==>$var2\n";
		#print"TEST==>$sign\n";
		$file{$line_num}="${space}while($var1 $sign $var2)\n";
	#	print"====|$file{$line_num}";
	}
	elsif($line=~/^do$/ || $line=~/^then$/){
		$file{$line_num}="${space}{\n";
	#	print"====|$file{$line_num}\n";
	}
	elsif($line=~/^done$/ || $line=~/^fi$/){
		$file{$line_num}="${space}}\n";
	#	print"====|$file{$line_num}\n";
	}
	elsif($line=~/([a-z]+) ?([^a-z0-9])\$\(\((.*)\)\)/){
	#	print"here#73=========>$line\n";
	#	print"$line\n";
		$line=~s/\s+//g;
	#	print"====no space=========>$line\n";
		$file{$line_num}="";
		$line=~s/\(|\)|\$//g;
		#print"$line\n";
		@temp_var=split /[\+\-\*\/\=\%]/,$line;
		@temp_sign=split /[a-z|0-9]+/,$line;
		# foreach $item (@temp_var){
		# 	print"test===item===>$item\n";
		# }
		# print"===============================";
		# foreach $sign (@temp_sign){
		# 	print"test===sign===>$sign\n";
		# }
		# print"test===line===>$line   |$#temp_sign|\n";
		while($#temp_sign!=0){
			$add_sign=pop @temp_sign;
			$add_var=pop @temp_var;
			if($add_var=~/^\d+.?\d*$/){
			#	print"This is a var |$add_var|\n";
			}else{
				$add_var="\$$add_var";
			}

			$file{$line_num}=$add_sign.$add_var.$file{$line_num};
		}
		$add_var=pop @temp_var;
		$add_var="\$$add_var";
		$file{$line_num}=$add_var.$file{$line_num};
		$file{$line_num}=$space.$file{$line_num}.";\n";
		#print"====|$file{$line_num}\n";
	}
	elsif($line=~/^echo(.*)/){
		#print"test=========echo part\n";
		$rest=$1;
		#print"test========$rest\n";
		$file{$line_num}="${space}print\"$rest\\n\";\n";
		#print"====|$file{$line_num}";
	}
	elsif($line=~/^if\s?\(\((.*)\)\)/){
		#print"Yes we can!\n";
		$catch=$1;
		$catch=~s/\s+//g;
		#print"test==>$catch\n";
		@temp_var=split /[\+\-\*\/\=\%]/,$catch;
		@temp_sign=split /[a-z|0-9]+/,$catch;
		#foreach $item (@temp_var){
		#	print"test===item===>$item\n";
		#}
		#print"===============================";
		#foreach $sign (@temp_sign){
	#		print"test===sign===>$sign\n";
	#	}
		while($#temp_sign!=0){
			$add_sign=pop @temp_sign;
			$add_var=pop @temp_var;
			while($add_var eq ""){
				$add_var=pop @temp_var;
			}
			if($add_var=~/^\d+.?\d*$/){
			#	print"This is a var |$add_var|\n";
			}else{
				$add_var="\$$add_var";
			}

			$file{$line_num}=$add_sign.$add_var.$file{$line_num};
		}
		$add_var=pop @temp_var;
		$add_var="\$$add_var";
		$file{$line_num}=$add_var.$file{$line_num};
		$file{$line_num}="${space}if\($file{$line_num}\)\n";
	#	print"====|$file{$line_num}";

		#print"test===line===>$line   |$#temp_sign|\n";
		#$file{$line_num}="if()\n";
		#print"====|$file{$line_num}|";
	}
	elsif($line=~/([a-z]+) ?([^a-z0-9])\$(.*)/){
#		print"here 153==============>$line\n";
		$line=~s/\s+//g;
		@temp_var=split /[\+\-\*\/\=\%]/,$line;
		@temp_sign=split /[a-z|0-9]+/,$line;
	####################################################################################	
#		foreach $item (@temp_var){
#			print"test===item===>$item\n";
#		}
#		print"===============================\n";
#		foreach $sign (@temp_sign){
#			print"test===sign===>$sign\n";
#		}
#		print"test===line===>$line   |$#temp_sign|\n";
#	##############################################################################
		while($#temp_sign!=0){
			$add_sign=pop @temp_sign;
			$add_var=pop @temp_var;
			$add_sign=~s/\$//g;
			while($add_var eq ""){
				$add_var=pop @temp_var;
			}
			while($add_sign eq ""){
				$add_sign=pop @temp_sign;
			}
			if($add_var=~/^\d+.?\d*$/){
			#	print"This is a var |$add_var|\n";
			}else{
				if($add_var=~/\$/){
				}else{
					$add_var="\$$add_var";
				}
			}
	#		print"|$add_sign|,|$add_var|\n";
			$file{$line_num}=$add_sign.$add_var.$file{$line_num};
		}
		$add_var=pop @temp_var;
		$add_var="\$$add_var";
		$file{$line_num}=$add_var.$file{$line_num};
		$file{$line_num}=$space.$file{$line_num}.";\n";
	#	print"====|$file{$line_num}";
	}
	elsif($line=~/else/){
		$file{$line_num}="${space}\}else\{\n";
	#	print"$file{$line_num}\n";
	}
	else{}
	$line_num++;
	#$line='';
}
close $input;
#print"============================================================================\n";
#open($zhazha,'>',$new_file_name)or die"zhazha error!\n";

foreach $key (sort {$a<=>$b} keys %file){
	#print $zhazha "$file{$key}";
	print"$file{$key}";
}
#close $zhazha;

#print"done!\n";
