#!/usr/local/bin/perl

if (@ARGV < 3)
{
	print "Usage: thr-one.pl <trace file> <cbr\\tcp> <receiving station>\n";
	exit;
}
$infile = $ARGV[0];
$kind = $ARGV[1];
$tonode=$ARGV[2];

#print "$tonode $granularity $packet_size\n";
#we compute how many bytes were transmitted during time specified by 
#granularity parameter in seconds.
$sum = 0; 
$clock = 0;
$header = 20;
$initial_clock = -1;
$final_clock = -1;
open (DATA, "<$infile") || die "Can't open $infile $!";
while (<DATA>) {
    $line = $_;
    @x = split(' ');
    last if ($x[4] =~ /END/);
    if ($initial_clock<0) {
    	$initial_clock = $x[1];
    }
    $final_clock = $x[1];
    #column 2 is time
    #checking if the event corresponds to a reception
    if ($x[0] eq 'r')
    {
       $line =~ /_(\d+)_/;
       $dest = $1;
       $size = $x[7];
       #print "$src $dest $size ";
       if ($line =~ /AGT/ &&  $dest eq $tonode &&  $x[6]=~/$kind/)
       {
	 # print $line;
	  $sum = $sum + $size-$header;
       }
       #print "$sum\n";
   }
    
 }
 $delta_t = $final_clock - $initial_clock + 0.000001;
 $throughput = $sum/$delta_t;
 print STDOUT "Throughput was: $throughput\n";
 close DATA;
 $throughput;




 

