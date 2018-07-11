#!/usr/bin/perl -w
####################### SUB ##########################
sub LoopCheck{#loop control
    while($#loop_flag!=-1){
        if($loop_flag[-1] eq $space){
            print"$loop_flag[-1]}\n";
            pop (@loop_flag);
            return;
        }
        elsif($loop_flag[-1] gt $space){
            print"$loop_flag[-1]}\n";
            pop (@loop_flag);
        }else{
            return;
        }
    }
}

sub TransformPolynomial{
    my $polynomial=$_[0];
    if($polynomial eq ""){
        return $polynomial;
    }
    my $SubResult="";
    my $add_sign="";
    my $add_var="";
    my @temp_var=split /[\+\-\*\/\=\%\:\>\<,\(\)]/,$polynomial;
    my @temp_sign=split /[a-z|0-9|_]+/,$polynomial;
    $last_flag=1;
    while($last_flag){
        $i=0;
        $last_flag=0;
        foreach $item (@temp_var){
            if($item eq ""){
                splice @temp_var,$i,1;
                $last_flag=1;
                last;
            }else{
                $i++;
            }
        }
    }
    $last_flag=1;
    while($last_flag){
        $i=0;
        $last_flag=0;
        foreach $item (@temp_sign){

            if($item eq ""){
                splice @temp_sign,$i,1;
                $last_flag=1;
                last;
            }else{
                $i++;
            }
        }
    }
    while($#temp_sign!=-1){
        $add_sign=pop @temp_sign;
        $add_var=pop @temp_var;
        if($add_var=~/^\d+.?\d*$/){
            #do nothing!
        }else{
            $add_var="\$$add_var";
        }
        $SubResult=$add_sign.$add_var.$SubResult;
    }
        $add_var=pop @temp_var;
        if($add_var=~/^\d+.?\d*$/){
        }else{
            $add_var="\$$add_var";
        }
        $SubResult=$add_var.$SubResult;
        return $SubResult;
}

sub PrintFunction{
    my $sub_input=$_[0];
    $return_result="";
    $sub_input =~ /^print\((.*)\)$/;
    $catch=$1;
    if($catch=~/^\"(.*)\"$/){
    	$temp=$1;
        $return_result="${space}print \"$temp\\n\"\;";
    }
    elsif($catch eq ""){
        $return_result=$space."print\"\\n\";";
    }
    elsif($catch=~/^"(.*)\" % (.*)$/){
        $catch1=$1;
        $catch2=$2;
        $catch1=~s/%[a-z]\s/\$line_count /;
        $return_result=$space."print \"$catch1\\n\";";
    }
    elsif($sub_input=~/^print\((.*),\s?end=\'(.*)\'\)/){
        $catch1=$1;
        $catch2=$2;
        $return_result=$space."print \"$catch1$catch2\\n;\"";
    }
    elsif($catch=~/^[a-zA-Z0-9]/){
        $catch=~s/\s+//g;
        $temp=TransformPolynomial($catch);
        #print"\$ThisIsALongLongVar=$temp;\n";
        #$return_result="${space}print \"\$ThisIsALongLongVar\\n\"\;";
        $return_result="${space}print \($temp\)\;".'print "\n";';
    }
    return $return_result;
}
#######################end SUB##########################



$loop_flag=qw();#this is used for check if the loop is over~
while ($line = <>) {
    chomp $line;
    $line=~/^(\s*)(.*)/;
    $space=$1;
    $line=$2;
    LoopCheck();
    $result="";#store the result of each lines~
    if ($line =~ /^#!/ && $. == 1) {
        $result= "#!/usr/bin/perl -w";
    }
    elsif($line=~/^import(.*)/){
        $result="\n";
    }
    elsif($line=~/^break$/){
        $result=$space."last;";
    }
    elsif ($line =~ /^(#|$)/) {
        $result= "$line";
    }
    elsif($line=~/sys.stdout.write\((.*)\)/){
        $result=$space."print $1;";
    }
    elsif($line=~/(.*)sys.stdin.readlines()/){
        $line=~s/\s+//g;
        $line=~/^(.*)=sys.stdin.readlines()/;
        $catch=$1;
        push @array,$catch;
        $result=$space."\$temp=\"\";\n".$space."while(\$temp=<STDIN>){\n".$space."    push \@$catch,\$temp;\n".$space."}";
    }
    elsif($line=~/(.*)sys.stdin.readline()(.*)/){
        @temp_var=split /=/,$line;
        $result=$space."\$".$temp_var[0]."=<STDIN>;";
    }
    elsif ($line =~ /^print(.*)$/) {
        $result=PrintFunction($line);
    }
    elsif($line=~/^if(.*):(.*)/){
        if($line=~/if(.*):$/){
            $catch=$1;
            $catch=~s/\s*//g;
            $result=$space."if ( ".TransformPolynomial($catch)." ) {";
            push (@loop_flag, $space);
        }else{
            $line=~s/^if//;
            $line=~s/\s*//g;
            $line=~/(.*):(.*)/;
            $head=$1;
            $tail=$2;
            $result=$space."if( ".TransformPolynomial($head).") { ".TransformPolynomial($tail).";}";
        }
    }
    elsif($line=~/^elif (.*):/){
        $catch=$1;
        $catch=~s/\s*//g;
        $result=$space."elsif (".TransformPolynomial($catch)."){";
        push (@loop_flag, $space);
    }
    elsif($line=~/else:/){
        $result=$space."else{";
        push (@loop_flag, $space);
    }
    elsif($line=~/for (.*) in sys.stdin:/){
        $result=$space."foreach \$$1 (<STDIN>){";
        push (@loop_flag, $space);
    }
    elsif($line=~/(.*).append\((.*)\)/){
        $line=~s/\s+//g;
        $line=~/(.*).append\((.*)\)/;
        $var1=$1;
        $var2=$2;
        $result=$space."push \@$var1, \$$var2;";
    }
    elsif($line=~/for (.*) in range\((.*)\):/){
        $head=$1;
        $tail=$2;
        $tail=~s/\s+//g;
        @temp_tail=split /,/,$tail;
        $temp_tail[0]=TransformPolynomial($temp_tail[0]);
        $temp_tail[1]=TransformPolynomial($temp_tail[1]);
        $temp_tail[1]=$temp_tail[1]."-1";
        $result=$space."foreach "."\$$head "."($temp_tail[0]..$temp_tail[1]){";
        push (@loop_flag, $space);
    }
    elsif($line=~/^while(.*)/){
        $line=~s/\s+//g;
        if($line=~/^while(.*):(.*);(.*)/){
            $head=$1;
            $mid=$2;
            $tail=$3;
            #for head
            $result="while( ".TransformPolynomial($head)." ){";
            #for mid temp
            if($mid=~/print\(?(.*)\)?/){
                $temp=PrintFunction($mid);
            }
            $result=$result.$temp." ";
            #for tail
            $result=$result.TransformPolynomial($tail).";}";
        }

        elsif($line=~/^while(.*):$/){
                $loop_flag=$space;
                $line=~/while\((.*)\)/;
                $result=$space."while(".TransformPolynomial($1)."){";
                push (@loop_flag, $space);
        }else{
                $line=~/^while(.*):(.*)/;
                $head=$1;
                $tail=$2;
                $result=$space."while(".TransformPolynomial($head)."){";
                $result=$result.TransformPolynomial($tail).";}";
        }

    }
    elsif($line=~/(.*)\s?=\s?\[\]/){
        $line=~s/\s+//g;
        $line=~/(.*)=\[\]$/;
        $catch=$1;
        push @array,$catch;
    }
    elsif($line=~/(.*)len\((.*)\)/){
        $line=~s/\s+//g;
        $line=~/(.*)len\((.*)\)/;
        $catch=$2;
        $line=~s/len\(|\)//g;
        $result=TransformPolynomial($line).";";
    }
    elsif($line =~/^[a-z0-9]+\s?[^a-z0-9:]\s?(.*)/){#a=(1*2)+3
        $line=~s/\s+//g;
        $result=$space.TransformPolynomial($line).";";
    }

    else{
        #can not figure out this line!
        $result=$line;
    }


    if($result=~/(.*)=(.*)\/\/(.*)/){
        $var1=$1;
        $var2=$2;
        $var3=$3;
        $var1=~s/\s+//;
        $result=$space."$var1=$var2/$var3;\n".$space."$var1=sprintf(\"%.0f\"\,$var1);";
    }
    foreach $item (@array){
        if($result=~/$item/){
            if($result=~/$item[^\[]/){
                $result=~s/\$$item/\@$item/;
            }else{
                $result=~/$item\[(.*)\]/;
                $catch=TransformPolynomial($1);
                $result=~s/$item\[(.*)\]/\$$item\[$catch\]/g;
            }
        }
    }
    print"$result\n";
}
#after all if there are still "{" in @loop_flag print all of them.
while($#loop_flag!=-1){
    $space=pop(@loop_flag);
    print"$space}\n";
}
