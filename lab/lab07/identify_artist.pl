#!/usr/bin/perl -w

sub make_artist_book{
	foreach $file (glob"lyrics/*.txt"){
		open F,"<",$file or die "There is no such file in the direction.";
		$file=~/lyrics\/(.*).txt/;
		$name=$1;
		$name=~s/_/ /g;
		foreach $line (<F>){
			$line=lc $line;
			@words=($line=~/[a-z]+/g);
			$num=$#words+1;
			$total_word{$name}+=$num;
			foreach $word (@words){
				$book{$name}{$word}++;
			}
		}
	}
}

make_artist_book();

foreach $name (keys %book){
	$result{$name}=0;
	foreach $word (keys %{$book{$name}}){
		$book{$name}{$word}=log(($book{$name}{$word}+1)/$total_word{$name});
	}
}

@check_file=@ARGV;



foreach $unamed_song_file (@check_file){
	open F,"<",$unamed_song_file or die "There is no such file in this direction.";
	#print "======>test $unamed_song_file\n";
	foreach $name (keys %result){
		$result{$name}=0;
	}
	
	foreach $line (<F>){
		$line =lc $line;
		@words=($line=~/[a-z]+/g);
		foreach $word (@words){
			foreach $name (keys %book){
				if (exists $book{$name}{$word}){
					$result{$name}+=$book{$name}{$word};
				}
				else{
					$result{$name}+=log(1/$total_word{$name});
				}
			}
		}
	}

	foreach $name (sort {$result{$b} <=> $result{$a}} keys %result){
		$result{$name}=sprintf("%.1f",$result{$name});
		print"$unamed_song_file most resembles the work of $name (log-probability=$result{$name})\n";
		last;
	}
}









