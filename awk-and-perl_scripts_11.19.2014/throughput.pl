#!/usr/local/bin/perl
if (@ARGV < 3)
{
	print "Usage: throughput.pl <trace file> <cbr\\tcp> <num stations of this kind>\n";
	exit;
}
$infile = $ARGV[0];
$kind = $ARGV[1];
$num_stations = $ARGV[2];
$header = 20;

$sum = 0;
$clock = 0;
$initial_clock = -1;
$final_clock = -1;
open (DATA, "<$infile") || die "Can't open $infile $!";

while (<DATA>) {
    $line = $_;
    @x = split(' ');
    if ($initial_clock<0) {
    	$initial_clock = $x[1];
    }
    $final_clock = $x[1];
    last if ($x[4] =~ /END/);
    if ($x[0] eq 'r' && $line =~ /AGT/ &&  $x[6]=~/$kind/)
    {
       $size = $x[7];     
       $sum = $sum + $size-$header;
    }
    
 }
 $delta_t = $final_clock - $initial_clock + 0.000001;
 $throughput = $sum/$delta_t;
 $throughput = $throughput/$num_stations;
 print STDOUT "Average Throughput was: $throughput\n";
 close DATA;
 exit(0);




 

