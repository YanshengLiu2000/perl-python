#!/usr/bin/perl -w

sub total_word{
	my $temp_file=$_[0];
	$num=0;
	#print"====================>$temp_file\n";
	open F,"<",$temp_file or die"There is no such file!";
	foreach $line (<F>){
		$line=lc $line;
		@words=($line=~/[a-z]+/g);
		$num+=$#words+1
	}
	#print "$num!!!!!!!!!!!!!!!!!\n";
	return $num;
}
sub count_word{
	$aim=$_[0];
	$num=0;
	my $temp_file=$_[1];
	open F,"<",$temp_file or die"There is no such file!";
	foreach $line (<F>){
		$line=lc $line;
		@words=($line=~/[a-z]+/g);
		foreach $word (@words){
			if($word eq $aim){$num++;}
		}
	}
	#print"========num in count word============>$num\n";
	return $num;
}


foreach $file (glob"lyrics/*.txt"){
	$total_word_in_file=total_word($file);
	$count_word_in_file=count_word($ARGV[0],$file);
	$result=($count_word_in_file+1)/$total_word_in_file;
	$result=log($result);
	$result=sprintf("%.4f",$result);
	$file=~/lyrics\/(.*).txt/;
	$name=$1;
	$name=~s/_/ /g;

	print "log(($count_word_in_file+1)/$total_word_in_file) = $result $name\n";

}
