#!/usr/bin/perl -w

$option = "";
foreach $course (@ARGV){
        if ($course eq "-d"){
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
}




















