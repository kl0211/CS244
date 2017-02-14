#!/usr/local/bin/perl

#change this to disable QoS


$res_dir = $ARGV[0];

system("rm -rf $res_dir"); 
system("mkdir $res_dir");

$difs=0.000040;
$cwmin = 15;

#num voice stations without ap!
$num_voice = 26; 

for($pf=1; $pf<=8; $pf++ ) 
{
 print ("Executing with pf = $pf\n");
 system("\/home\/itai\/ns-allinone-2.27\/ns-2.27\/ns test-ud.tcl $num_voice $difs $cwmin $pf >& tmpsim.out");
 system ("rm -f tmpsim.out"); 
}

`cp -f d*_cw*_pf*.tr $res_dir\/`; 

open(RES, ">$res_dir\/results-pf");
for($pf=1; $pf<=8; $pf++ ) 
{
    print "Analizing results for pf = $pf \n";
    print RES "difs  =  $difs cwmin = $cwmin  pf = $pf \n";
    print RES "------------------------------------------\n";
    $temp = $difs * 100000;   
@thr_one = `perl scripts\/updown-link-thr.pl $res_dir\/d$temp\\e-05_cw$cwmin\_pf$pf.tr cbr $num_voice`;
    print RES @thr_one;
}

close RES;
