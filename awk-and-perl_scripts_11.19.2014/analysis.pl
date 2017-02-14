#!/usr/bin/perl

use strict;


# to check the command line option
if($#ARGV<0){
    printf("Usage: <trace-file>\n");
    exit 1;
}

# to open the given trace file
open(Trace, $ARGV[0]) or die "Cannot open the trace file";



my $sc = 0;  # sending counter
my $rc = 0;  # receiving counter

my %pkt_fc = ();  #packet forwarding counter

while(<Trace>){ # read one line in from the file
    
    my @line = split;  #split the line with delimin as space

    if($line[3] eq "AGT" && $line[6] eq "cbr"){ # an application agent trace line 
	if($line[0] eq "s"){ # a packet sent by some data source
	    $sc++;
	    $pkt_fc{$line[5]} = 0;  #define the forwarding couter for this pkt 
	}
	if($line[0] eq "r"){ # a packet received by sink
	    $rc++;
	    $pkt_fc{$line[5]}++;  # one more hop to complement
	}
    }

    if($line[3] eq "RTR"){ # a routing agent trace line
	if($line[0] eq "f"){
	    $pkt_fc{$line[5]}++;
	}
    }
}

close(Trace); #close the file 

my $temp_rc =0;
my $pkt = 0;
foreach $pkt ( keys %pkt_fc ) {
    $temp_rc += $pkt_fc{$pkt}; #the total forwarding times
}


if($rc > 0){
    printf("Received ratio %f, average path length %f\n", $rc/$sc, $temp_rc/$rc);
}
