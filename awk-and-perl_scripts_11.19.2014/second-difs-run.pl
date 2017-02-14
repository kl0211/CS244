#!/usr/local/bin/perl

#change this to disable QoS


$res_dir = $ARGV[0];

system("rm -rf $res_dir"); 
system("mkdir $res_dir");

$cwmin = 15;
$pf = 2;

#num voice stations without ap!
$num_voice = 8; 

for($difs=0.000020; $difs<=0.000080; $difs = $difs + 0.000010) 
{
  print ("Executing with difs = $difs\n");
  system("\/home\/itai\/ns-allinone-2.27\/ns-2.27\/ns test-ud.tcl $ num_voice $difs $cwmin $pf >& tmpsim.out");
#  system ("rm -f tmpsim.out");
}
`cp -f d*_cw*_pf*.tr $res_dir\/`; 


open(RES, ">$res_dir\/results-difs");
for($difs=0.000020; $difs<=0.000080; $difs = $difs + 0.000010) 
{
    print "Analizing results for difs = $difs \n";
    print RES "difs  =  $difs cwmin = $cwmin  pf = $pf \n";
    print RES "------------------------------------------\n";
    $temp = $difs * 100000;
@thr_one=`perl scripts\/updown-link-thr.pl $res_dir\/d$temp\\e-05_cw$cwmin\_pf$pf.tr cbr $num_voice`;
   print RES @thr_one;
}

close RES;
