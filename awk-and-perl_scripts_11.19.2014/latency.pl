#!/usr/local/bin/perl
#Explanation: The send time is when the packet leaves the Udp (Agent) layer and
#when the channel is busier the time it takes till the mac layer decides to transmit
#the packet is longer. (CW is higher at this stage) So latency gets longer.
if (@ARGV < 2)
{
	print "Usage: latency.pl <trace file> <cbr\\tcp>\n";
	exit;
}
$infile = $ARGV[0];
$kind = $ARGV[1];

$sum_latency = 0;
$num_counted = 0;
%packet_hash=();
open (DATA, "<$infile") || die "Can't open $infile";
while (<DATA>) {
    $line = $_;
    @x = split(' ');
    $id = $x[5];
    last if ($x[4] =~ /END/);    
    next if ($line !~ /AGT/ || $x[6] !~ /$kind/); 
    if ($x[0] eq 's')
    {
	$packet_hash{$id} = $x[1];
    } 
    elsif ($x[0] eq 'r')
    {
       	$latency = $x[1] - $packet_hash{$id};
        $sum_latency = $sum_latency + $latency;
        $num_counted++;
    }
}

 
 $avg = $sum_latency/$num_counted;
 
 print STDOUT "Average $kind latency was: $avg\n";
 close DATA;
 exit(0);




 

