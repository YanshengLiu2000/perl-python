#!/usr/bin/perl -w

$option = "";

foreach $course (@ARGV){
        if ($course eq "-d" or $course eq "-t"){
                $option = $course;
                next;
        }
        if ($option eq ""){
                $url = "http://timetable.unsw.edu.au/current/$course.html";
                open F, "wget -q -O- $url|" or die;
                $current_line = "";
                $times = "";
                $times1 = "";
                $sem = "";
                $sem1 = "";
                $skip1_line = "";
                $skip2_line = "";
                $skip3_line = "";
                $skip4_line = "";
                $skip5_line = "";
                while ($line = <F>){
                        if ($current_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip1_line = $current_line;
                                $sem = $current_line;
                                $sem =~ s/(.*)"#//;
                                $sem =~ s/-\d.*(.*)//;
                                $sem =~ s/\s$//;
                                $current_line = "";
                                next;
                        }
                        if ($skip1_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip2_line = $skip1_line;
                                $skip1_line = "";
                                next;
                        }
                        if ($skip2_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip3_line = $line;
                                $skip3_line =~ s/(.*)\d{4}">//;
                                $skip3_line =~ s/<(.*)$//;
                                $skip3_line =~ s/\s//;
                                $skip2_line = "";
                                next;
                        }
                        if ($skip3_line ne "WEB" and $skip3_line ne ""){
                                $skip4_line = $line;
                                $skip3_line = "";
                                next;
                        }
                        if ($skip4_line =~ /(.*)<td class="data"><font color(.*)/){
                                $skip5_line = $skip4_line;
                                $skip4_line = "";
                                next;
                        }
                        if ($skip5_line =~ /(.*)<td class="data"><font color(.*)/){
                                $times = $line;
                                $times =~ s/<td class="data">//;
                                $times =~ s/<(.*)//;
                                $times =~ s/\s$//;
                                $times =~ s/^\s*//;
                                print "$course: $sem $times\n" if $sem ne $sem1 or $times ne $times1;
                                $sem1 = $sem;
                                $times1 = $times;
                                $skip5_line = "";
                                next;
                        }
                        if ($line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $current_line = $line;
                        }
                }
        }
        if ($option eq "-d"){
                $url = "http://timetable.unsw.edu.au/current/$course.html";
                open F, "wget -q -O- $url|" or die;
                $current_line = "";
                $skip1_line = "";
                $skip2_line = "";
                $skip3_line = "";
                $skip4_line = "";
                $skip5_line = ""; 
                $times = "";
                $times1 = "";
                $sem = "";
                $sem1 = "";  
                while ($line = <F>){
                        if ($current_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip1_line = $current_line;
                                $sem = $current_line;
                                $sem =~ s/(.*)"#//;
                                $sem =~ s/-\d.*(.*)//;
                                $sem =~ s/\s$//;
                                $current_line = "";
                                next;
                        }
                        if ($skip1_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip2_line = $skip1_line;
                                $skip1_line = "";
                                next;
                        }
                        if ($skip2_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip3_line = $line;
                                $skip3_line =~ s/(.*)\d{4}">//;
                                $skip3_line =~ s/<(.*)$//;
                                $skip3_line =~ s/\s//;
                                $skip2_line = "";
                                next;
                        }
                        if ($skip3_line ne "WEB" and $skip3_line ne ""){
                                $skip4_line = $line;
                                $skip3_line = "";
                                next;
                        }
                        if ($skip4_line =~ /(.*)<td class="data"><font color(.*)/){
                                $skip5_line = $skip4_line;
                                $skip4_line = "";
                                next;
                        }
                        if ($skip5_line =~ /(.*)<td class="data"><font color(.*)/){
                                $times = $line;
                                $times =~ s/<td class="data">//;
                                $times =~ s/<(.*)//;
                                $times =~ s/\s$//;
                                $times =~ s/^\s*//;
                                @t = split/\),/, $times;
                                foreach $t (@t){
                                        if ($sem ne $sem1 or $times ne $times1){
                                                $t =~ s/\(.*//;
                                                $t =~ s/^\s*//;
                                                $days = $t;
                                                $days =~ s/ \d.+//;
                                                @days = split/, /, $days;
                                                foreach $day (@days){
                                                        $hours = $t;
                                                        $hours =~ s/\w{3}(,?)\s//g;
                                                        @shours = split/ - /, $hours;
                                                        $hour1 = $shours[0];
                                                        $hour1 =~ s/:.*//;
                                                        $hour1 =~ s/^0//;
                                                        $hour2 = $shours[1];
                                                        $hour2 =~ s/:.*//;
                                                        $hour2 =~ s/^0//;
                                                        @minutes = split/:/, $hours;
                                                        $sminutes = $minutes[2];
                                                        if ($sminutes =~ /(.*)00(.*)/){
                                                                @dhours = eval($hour1)..eval($hour2 - 1);
                                                        } else {
                                                                @dhours = eval($hour1)..eval($hour2);
                                                        }
                                                        foreach $hour (@dhours){
                                                                $p = "$sem $course $day $hour";
                                                                if (grep{$p eq $_} @pp){
                                                                        next;
                                                                } else {
                                                                        print "$p\n";
                                                                        push @pp, $p;
                                                                }
                                                        }
                                                }
                                        }
                                }
                                $sem1 = $sem;
                                $times1 = $times;
                                $skip5_line = "";
                                next;
                        }
                        if ($line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $current_line = $line;
                        }
                }             
        }
        if ($option eq "-t"){
                $url = "http://timetable.unsw.edu.au/current/$course.html";
                open F, "wget -q -O- $url|" or die;
                $current_line = "";
                $skip1_line = "";
                $skip2_line = "";
                $skip3_line = "";
                $skip4_line = "";
                $skip5_line = ""; 
                $times = "";
                $times1 = "";
                $sem = "";
                $sem1 = "";  
                while ($line = <F>){
                        if ($current_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip1_line = $current_line;
                                $sem = $current_line;
                                $sem =~ s/(.*)"#//;
                                $sem =~ s/-\d.*(.*)//;
                                $sem =~ s/\s$//;
                                $sems1 = 1 if $sem =~ /S1/;
                                $sems2 = 1 if $sem =~ /S2/;
                                $semx1 = 1 if $sem =~ /X1/;
                                $current_line = "";
                                next;
                        }
                        if ($skip1_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip2_line = $skip1_line;
                                $skip1_line = "";
                                next;
                        }
                        if ($skip2_line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $skip3_line = $line;
                                $skip3_line =~ s/(.*)\d{4}">//;
                                $skip3_line =~ s/<(.*)$//;
                                $skip3_line =~ s/\s//;
                                $skip2_line = "";
                                next;
                        }
                        if ($skip3_line ne "WEB" and $skip3_line ne ""){
                                $skip4_line = $line;
                                $skip3_line = "";
                                next;
                        }
                        if ($skip4_line =~ /(.*)<td class="data"><font color(.*)/){
                                $skip5_line = $skip4_line;
                                $skip4_line = "";
                                next;
                        }
                        if ($skip5_line =~ /(.*)<td class="data"><font color(.*)/){
                                $times = $line;
                                $times =~ s/<td class="data">//;
                                $times =~ s/<(.*)//;
                                $times =~ s/\s$//;
                                $times =~ s/^\s*//;
                                @t = split/\),/, $times;
                                foreach $t (@t){
                                        if ($sem ne $sem1 or $times ne $times1){
                                                $t =~ s/\(.*//;
                                                $t =~ s/^\s*//;
                                                $days = $t;
                                                $days =~ s/ \d.+//;
                                                @days = split/, /, $days;
                                                foreach $day (@days){
                                                        $hours = $t;
                                                        $hours =~ s/\w{3}(,?)\s//g;
                                                        @shours = split/ - /, $hours;
                                                        $hour1 = $shours[0];
                                                        $hour1 =~ s/:.*//;
                                                        $hour1 =~ s/^0//;
                                                        $hour2 = $shours[1];
                                                        $hour2 =~ s/:.*//;
                                                        $hour2 =~ s/^0//;
                                                        @minutes = split/:/, $hours;
                                                        $sminutes = $minutes[2];
                                                        if ($sminutes =~ /(.*)00(.*)/){
                                                                @dhours = eval($hour1)..eval($hour2 - 1);
                                                        } else {
                                                                @dhours = eval($hour1)..eval($hour2);
                                                        }
                                                        foreach $hour (@dhours){
                                                                $p = "$sem $course $day $hour";
                                                                if (grep{$p eq $_} @pp){
                                                                        next;
                                                                } else {
                                                                        $e{$sem}{$day}{$hour} += 1;
                                                                        push @pp, $p;
                                                                }
                                                        }
                                                }
                                        }
                                }
                                $sem1 = $sem;
                                $times1 = $times;
                                $skip5_line = "";
                                next;
                        }
                        if ($line =~ /(.*)\d{4}">Lecture<(.*)/){
                                $current_line = $line;
                        }
                }             
        }
}

if ($option eq "-t"){
        foreach $n (9..20){
                if ($sems1){
                        $e{S1}{Mon}{$n} = "" if !$e{S1}{Mon}{$n};
                        $e{S1}{Tue}{$n} = "" if !$e{S1}{Tue}{$n};
                        $e{S1}{Wed}{$n} = "" if !$e{S1}{Wed}{$n};
                        $e{S1}{Thu}{$n} = "" if !$e{S1}{Thu}{$n};
                        $e{S1}{Fri}{$n} = "" if !$e{S1}{Fri}{$n};
                }
                if ($sems2){
                        $e{S2}{Mon}{$n} = "" if !$e{S2}{Mon}{$n};
                        $e{S2}{Tue}{$n} = "" if !$e{S2}{Tue}{$n};
                        $e{S2}{Wed}{$n} = "" if !$e{S2}{Wed}{$n};
                        $e{S2}{Thu}{$n} = "" if !$e{S2}{Thu}{$n};
                        $e{S2}{Fri}{$n} = "" if !$e{S2}{Fri}{$n};
                }
                if ($semx1){
                        $e{X1}{Mon}{$n} = "" if !$e{X1}{Mon}{$n};
                        $e{X1}{Tue}{$n} = "" if !$e{X1}{Tue}{$n};
                        $e{X1}{Wed}{$n} = "" if !$e{X1}{Wed}{$n};
                        $e{X1}{Thu}{$n} = "" if !$e{X1}{Thu}{$n};
                        $e{X1}{Fri}{$n} = "" if !$e{X1}{Fri}{$n};                      
                }
        }
        if ($sems1){
                printf "S1\tMon\tTue\tWed\tThu\tFri\n";
                printf "09:00\t $e{S1}{Mon}{9}\t $e{S1}{Tue}{9}\t $e{S1}{Wed}{9}\t $e{S1}{Thu}{9}\t $e{S1}{Fri}{9}\n";
                printf "10:00\t $e{S1}{Mon}{10}\t $e{S1}{Tue}{10}\t $e{S1}{Wed}{10}\t $e{S1}{Thu}{10}\t $e{S1}{Fri}{10}\n";
                printf "11:00\t $e{S1}{Mon}{11}\t $e{S1}{Tue}{11}\t $e{S1}{Wed}{11}\t $e{S1}{Thu}{11}\t $e{S1}{Fri}{11}\n";
                printf "12:00\t $e{S1}{Mon}{12}\t $e{S1}{Tue}{12}\t $e{S1}{Wed}{12}\t $e{S1}{Thu}{12}\t $e{S1}{Fri}{12}\n";
                printf "13:00\t $e{S1}{Mon}{13}\t $e{S1}{Tue}{13}\t $e{S1}{Wed}{13}\t $e{S1}{Thu}{13}\t $e{S1}{Fri}{13}\n";
                printf "14:00\t $e{S1}{Mon}{14}\t $e{S1}{Tue}{14}\t $e{S1}{Wed}{14}\t $e{S1}{Thu}{14}\t $e{S1}{Fri}{14}\n";
                printf "15:00\t $e{S1}{Mon}{15}\t $e{S1}{Tue}{15}\t $e{S1}{Wed}{15}\t $e{S1}{Thu}{15}\t $e{S1}{Fri}{15}\n"; 
                printf "16:00\t $e{S1}{Mon}{16}\t $e{S1}{Tue}{16}\t $e{S1}{Wed}{16}\t $e{S1}{Thu}{16}\t $e{S1}{Fri}{16}\n";
                printf "17:00\t $e{S1}{Mon}{17}\t $e{S1}{Tue}{17}\t $e{S1}{Wed}{17}\t $e{S1}{Thu}{17}\t $e{S1}{Fri}{17}\n";
                printf "18:00\t $e{S1}{Mon}{18}\t $e{S1}{Tue}{18}\t $e{S1}{Wed}{18}\t $e{S1}{Thu}{18}\t $e{S1}{Fri}{18}\n";
                printf "19:00\t $e{S1}{Mon}{19}\t $e{S1}{Tue}{19}\t $e{S1}{Wed}{19}\t $e{S1}{Thu}{19}\t $e{S1}{Fri}{19}\n"; 
                printf "20:00\t $e{S1}{Mon}{20}\t $e{S1}{Tue}{20}\t $e{S1}{Wed}{20}\t $e{S1}{Thu}{20}\t $e{S1}{Fri}{20}\n";
        }
        if ($sems2){
                printf "S2\tMon\tTue\tWed\tThu\tFri\n";
                printf "09:00\t $e{S2}{Mon}{9}\t $e{S2}{Tue}{9}\t $e{S2}{Wed}{9}\t $e{S2}{Thu}{9}\t $e{S2}{Fri}{9}\n";
                printf "10:00\t $e{S2}{Mon}{10}\t $e{S2}{Tue}{10}\t $e{S2}{Wed}{10}\t $e{S2}{Thu}{10}\t $e{S2}{Fri}{10}\n";
                printf "11:00\t $e{S2}{Mon}{11}\t $e{S2}{Tue}{11}\t $e{S2}{Wed}{11}\t $e{S2}{Thu}{11}\t $e{S2}{Fri}{11}\n";
                printf "12:00\t $e{S2}{Mon}{12}\t $e{S2}{Tue}{12}\t $e{S2}{Wed}{12}\t $e{S2}{Thu}{12}\t $e{S2}{Fri}{12}\n";
                printf "13:00\t $e{S2}{Mon}{13}\t $e{S2}{Tue}{13}\t $e{S2}{Wed}{13}\t $e{S2}{Thu}{13}\t $e{S2}{Fri}{13}\n";
                printf "14:00\t $e{S2}{Mon}{14}\t $e{S2}{Tue}{14}\t $e{S2}{Wed}{14}\t $e{S2}{Thu}{14}\t $e{S2}{Fri}{14}\n";
                printf "15:00\t $e{S2}{Mon}{15}\t $e{S2}{Tue}{15}\t $e{S2}{Wed}{15}\t $e{S2}{Thu}{15}\t $e{S2}{Fri}{15}\n"; 
                printf "16:00\t $e{S2}{Mon}{16}\t $e{S2}{Tue}{16}\t $e{S2}{Wed}{16}\t $e{S2}{Thu}{16}\t $e{S2}{Fri}{16}\n";
                printf "17:00\t $e{S2}{Mon}{17}\t $e{S2}{Tue}{17}\t $e{S2}{Wed}{17}\t $e{S2}{Thu}{17}\t $e{S2}{Fri}{17}\n";
                printf "18:00\t $e{S2}{Mon}{18}\t $e{S2}{Tue}{18}\t $e{S2}{Wed}{18}\t $e{S2}{Thu}{18}\t $e{S2}{Fri}{18}\n";
                printf "19:00\t $e{S2}{Mon}{19}\t $e{S2}{Tue}{19}\t $e{S2}{Wed}{19}\t $e{S2}{Thu}{19}\t $e{S2}{Fri}{19}\n"; 
                printf "20:00\t $e{S2}{Mon}{20}\t $e{S2}{Tue}{20}\t $e{S2}{Wed}{20}\t $e{S2}{Thu}{20}\t $e{S2}{Fri}{20}\n";
        }
        if ($semx1){
                printf "X1\tMon\tTue\tWed\tThu\tFri\n";
                printf "09:00\t $e{X1}{Mon}{9}\t $e{X1}{Tue}{9}\t $e{X1}{Wed}{9}\t $e{X1}{Thu}{9}\t $e{X1}{Fri}{9}\n";
                printf "10:00\t $e{X1}{Mon}{10}\t $e{X1}{Tue}{10}\t $e{X1}{Wed}{10}\t $e{X1}{Thu}{10}\t $e{X1}{Fri}{10}\n";
                printf "11:00\t $e{X1}{Mon}{11}\t $e{X1}{Tue}{11}\t $e{X1}{Wed}{11}\t $e{X1}{Thu}{11}\t $e{X1}{Fri}{11}\n";
                printf "12:00\t $e{X1}{Mon}{12}\t $e{X1}{Tue}{12}\t $e{X1}{Wed}{12}\t $e{X1}{Thu}{12}\t $e{X1}{Fri}{12}\n";
                printf "13:00\t $e{X1}{Mon}{13}\t $e{X1}{Tue}{13}\t $e{X1}{Wed}{13}\t $e{X1}{Thu}{13}\t $e{X1}{Fri}{13}\n";
                printf "14:00\t $e{X1}{Mon}{14}\t $e{X1}{Tue}{14}\t $e{X1}{Wed}{14}\t $e{X1}{Thu}{14}\t $e{X1}{Fri}{14}\n";
                printf "15:00\t $e{X1}{Mon}{15}\t $e{X1}{Tue}{15}\t $e{X1}{Wed}{15}\t $e{X1}{Thu}{15}\t $e{X1}{Fri}{15}\n"; 
                printf "16:00\t $e{X1}{Mon}{16}\t $e{X1}{Tue}{16}\t $e{X1}{Wed}{16}\t $e{X1}{Thu}{16}\t $e{X1}{Fri}{16}\n";
                printf "17:00\t $e{X1}{Mon}{17}\t $e{X1}{Tue}{17}\t $e{X1}{Wed}{17}\t $e{X1}{Thu}{17}\t $e{X1}{Fri}{17}\n";
                printf "18:00\t $e{X1}{Mon}{18}\t $e{X1}{Tue}{18}\t $e{X1}{Wed}{18}\t $e{X1}{Thu}{18}\t $e{X1}{Fri}{18}\n";
                printf "19:00\t $e{X1}{Mon}{19}\t $e{X1}{Tue}{19}\t $e{X1}{Wed}{19}\t $e{X1}{Thu}{19}\t $e{X1}{Fri}{19}\n"; 
                printf "20:00\t $e{X1}{Mon}{20}\t $e{X1}{Tue}{20}\t $e{X1}{Wed}{20}\t $e{X1}{Thu}{20}\t $e{X1}{Fri}{20}\n";
        }         
}




















