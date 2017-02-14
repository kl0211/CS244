#!/usr/local/bin/perl

#change this to disable QoS
$e_enb = 1;

$res_dir = $ARGV[0];

system("rm -rf $res_dir"); 
system("mkdir $res_dir");

#
for($i=2; $i<=20; $i = $i + 2) 
{
	print ("Executing with $i voice nodes\n");
        system("\/home\/itai\/ns-allinone-2.27\/ns-2.27\/ns test.tcl $i $e_enb >& tmpsim.out");
	system ("rm -f tmpsim.out");
	system("cp -f test-out_$i.tr $res_dir\/");
}

open(RES, ">$res_dir\/results-e");
for ($i=2; $i<=20; $i = $i + 2) 
{
	print "Analizing results for $i voice nodes ...\n";
	print RES "number of voice nodes: $i\n";
	print RES "------------------------------\n";
	@thr_one = `perl scripts\/throughput.pl $res_dir\/test-out_$i.tr cbr $i`;
	print RES @thr_one;
	@lat_one = `perl scripts\/latency.pl $res_dir\/test-out_$i.tr cbr`;
	print RES @lat_one;
	@los_one = `perl scripts\/packetloss.pl $res_dir\/test-out_$i.tr cbr`;
	print RES @los_one;
}

close RES;
