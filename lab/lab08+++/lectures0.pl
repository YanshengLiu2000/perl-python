#!/usr/bin/perl -w

foreach $course (@ARGV){
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