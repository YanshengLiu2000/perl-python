#!/usr/bin/perl -w

# Starting point for COMP[29]041 assignment 1
# http://www.cse.unsw.edu.au/~cs2041/assignments/pypl
# written by andrewt@unsw.edu.au September 2017
sub LoopCheck{
    if($loop_flag ne "" && $loop_flag ne $space){
        print"$loop_flag}\n";
        $loop_flag="";
    }
}
$line ='     x = x + 1';
chomp $line;
$line=~/^(\s*)[a-z]/;
$space=$1;
$line=~s/\s+//;
$loop_flag="";#this is used for check if the loop is over~

LoopCheck();
if ($line =~ /^#!/ && $. == 1) {
    print"TEST==Line 21===>";#test
    print "${space}#!/usr/bin/perl -w\n";
}
elsif ($line =~ /^(#|$)/) {
    print"TEST==Line 25===>";#test
    print "$line\n";
}
elsif ($line =~ /^print\((.*)\)$/) {
    $catch=$1;
#        print"TEST==Line 23===>";#test
#        print"$line====$catch\n";#test
    if($catch=~/\"(.*)\"/){
        print"test=======>";
        print"${space}print \"$1\\n\"\;\n";
    }
    else{
        print"${space}print \"\$$1\\n\"\;\n";
    }
}
elsif($line=~/^while(.*)/){
    $loop_flag=$space;
    $line=~s/while//;
    $line=~s/\s+//g;
    print"TEST==Line 44===>";#test
    print"$line\n";#test
    @temp_var=split /[\+\-\*\/\=\%\:\>\<]/,$line;
    @temp_sign=split /[a-z|0-9]+/,$line;
    #test===
    foreach $item (@temp_var){
    	print"test===item===>$item\n";
    }
    foreach $sign (@temp_sign){
    	print"test===sign===>$sign\n";
    }
    print"test===line===>$line   |$#temp_sign|\n";
    #test===
    $result="";
    while($#temp_sign!=0){
        $add_sign=pop @temp_sign;
        $add_var=pop @temp_var;
        if($add_sign eq ":"){
            $add_sign="){"
        }
        if($add_var=~/^\d+.?\d*$/){
        }else{
            $add_var="\$$add_var";
        }
        $result=$add_sign.$add_var.$result;
    }
        $add_var=pop @temp_var;
        if($add_var=~/^\d+.?\d*$/){
        }else{
            $add_var="\$$add_var";
        }
        $result = $space."while (".$add_var.$result.";\n";
        #$result=$space."while"."("$add_var.$result.")".";";
        print"This is the result=========>";#test
        print"|$result|\n";

#######need add () and {}
}
elsif($line =~/^[a-z0-9]+\s?[^a-z0-9:]\s?(.*)/){#a=(1*2)+3
    $line=~s/\s+//g;
    print"TEST==Line 84===>";#test
    print"$line\n";#test
    @temp_var=split /[\+\-\*\/\=\%]/,$line;
    @temp_sign=split /[a-z|0-9]+/,$line;
    #test===
    # foreach $item (@temp_var){
    # 	print"test===item===>$item\n";
    # }
    # foreach $sign (@temp_sign){
    # 	print"test===sign===>$sign\n";
    # }
    # print"test===line===>$line   |$#temp_sign|\n";
    #test===
    $result="";
    while($#temp_sign!=0){
        $add_sign=pop @temp_sign;
        $add_var=pop @temp_var;
        if($add_var=~/^\d+.?\d*$/){
        }else{
            $add_var="\$$add_var";
        }
        $result=$add_sign.$add_var.$result;
    }
        $add_var=pop @temp_var;
        $add_var="\$$add_var";
        $result=$space.$add_var.$result.";";
        print"This is the result=========>";#test
        print"$result\n";
}
else{
    print"can not read this line\n";#test
}
# check check
#test2
#test3
