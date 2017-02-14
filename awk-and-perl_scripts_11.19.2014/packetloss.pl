#!/usr/local/bin/perl

if (@ARGV < 2)
{
	print "Usage: packetloss.pl <trace file> <cbr//tcp>\n";
	exit;
}
$infile = $ARGV[0];
$kind = $ARGV[1];

$sum_sent = 0;
$num_dropped = 0;

open (DATA, "<$infile") || die "Can't open $infile $!";
while (<DATA>) {
    $line = $_;
    @x = split(' ');
    last if ($x[4] =~ /END/);
    $num_sent++  if ($x[0] eq 's' && $x[6] =~ /$kind/);
    $num_dropped++ if ($x[0] eq 'D' && $line =~ /IFQ/ && $x[6] =~ /$kind/); 
 }
 
 $dropped_ratio = 100*$num_dropped/$num_sent;
 
 print STDOUT "Percentage of $kind packets that were dropped: ${dropped_ratio}%\n";
 close DATA;
 exit(0);




 

