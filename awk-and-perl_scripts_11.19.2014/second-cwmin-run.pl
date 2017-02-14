#!/usr/local/bin/perl

$res_dir = $ARGV[0];

system("rm -rf $res_dir"); 
system("mkdir $res_dir");

$difs =0.000040;
$pf = 2;

#num voice stations without ap!
$num_voice = 25; 
$exp = 2;
for($cwmin = 3; $cwmin<=31; $cwmin = 2**$exp-1) 
{
 print ("Executing with cwmin = $cwmin\n");
 system("\/home\/itai\/ns-allinone-2.27\/ns-2.27\/ns test-ud.tcl $num_voice $difs $cwmin $pf >& tmpsim.out");
 system ("rm -f tmpsim.out");
 $exp++;
}

`cp -f d*_cw*_pf*.tr $res_dir\/`; 
$exp = 2;
open(RES, ">$res_dir\/results-cwmin");
for($cwmin = 3; $cwmin<=31; $cwmin = 2**$exp-1) 
{
    print "Analizing results for cwmin = $cwmin \n";
    print RES "difs  =  $difs cwmin = $cwmin  pf = $pf \n";
    print RES "------------------------------------------\n";
    $temp = $difs*100000; 
@thr_one = `perl scripts\/updown-link-thr.pl $res_dir\/d$temp\\e-05_cw$cwmin\_pf$pf.tr cbr $num_voice`;
    print RES @thr_one;
    $exp++;
}

close RES;
