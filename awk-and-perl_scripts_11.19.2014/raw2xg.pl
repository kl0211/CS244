eval 'exec perl -S $0 ${1+"$@"}'	# -*-perl-*-
    if 0;

require 5.001;

($progname) = ($0 =~ m!([^/]+)$!);
sub usage {
    print STDERR <<END;
usage: $progname [options] [trace files...]

options:
-a plot acks
-s SCALE scale TCP sequence numbers by SCALE
-n FACTOR scale flow number by FACTOR
-m MODULUS treat TCP sequence numbers as mod MODULUS
-q show queueing delay by connecting lines
-l show packet length
-t TITLE title of test
-e plot ecn flags
-d plot only drops and ECN marks
-v plot events
-c leave out empty lists
-x really leave out ALL of the empty lists
-f plot acks from tcp-full
-g for plotting acks from tcp-full, one direction has source 0
-p don't add the x-graph preface
-y fix the y-axis when there are no drops
-r plot arrivals only

Traditional ``wrapping'' ns plots (as called from the test scripts)
can be generated with -s 0.01 -m 90.
END
    exit 1;
};
$usage = "usage: $progname [-a] [trace files...]\n";

require 'getopts.pl';
&Getopts('acefgds:m:n:qrplvt:xy') || usage;

$c = 0;
@p = @pc = @pg = @a = @ac = @ae = @d = @lu = @ld = ();
@vto = @vss = @vfr = @vrfr = @vnrfr = @vfc = ();
%q_time_seg = ();
$scale = defined($opt_s) ? $opt_s : 1;
$modulus = defined($opt_m) ? $opt_m : 2 ** 31;
$flow_factor = defined($opt_n) ? $opt_n : 1;
$plot_acks = defined($opt_a);
$plot_ecn = defined($opt_e);
$plot_drops = defined($opt_d);
$plot_event = defined($opt_v);
$no_padding = defined($opt_c);
$really_no_padding = defined($opt_x);
$plot_full = defined($opt_f);
$source_zero = defined($opt_g);
$no_title = defined($opt_p);
$last_line = defined($opt_y);
$plot_arrivals = defined($opt_r);

$file = $acks = '';

sub translate_point {
    my($time, $seq, $flow) = @_;
    if ($seq == -1) {$seq = 0;}
    $plotted = $flow * $flow_factor + ($seq % $modulus) * $scale;
    $plotted =~ s/\.e/e/g; # to ensure Cygwin compatibility,
    return ($time, $plotted);
}

while (<>) {
    $dfile = $ARGV;
    @F = split;
    /testName/ && ($file = $F[2], next);
    /^[\+-] / && do {
$c = $F[7] if ($c < $F[7]);
$is_ack = ($F[4] eq 'ack' || $F[4] eq 'tcpFriendCtl');
$is_ecn = ($F[6] =~ /E/);
$is_cong = ($F[6] =~ /A/);
$is_echo = ($F[6] =~ /C/);
$is_tcp = ($F[4] eq 'tcp');
$source_0 = ($F[8] eq '0.0');
$large_pkt = ($F[5] > 40);
next if ($is_ack && !$plot_acks);
next if (($F[0] eq "-") && $plot_arrivals);
### if ($large_pkt) { print("Large");} else {print("Small");}

$use_full = 0;
if ($plot_full){ $use_full = 1;}
## if ($plot_full){if ($large_pkt) { $use_full = 1;}}
##if (!$source_zero) { $use_full = 1;
## } else { if ($source_0) { if ($is_tcp) { $use_full = 1; }
## }}}
if ($use_full == 1){
## ($plot_full && (!$source_zero || ($source_0 && $is_tcp)))
   ## F[10]: seq. no.; F[12]: ack no.;
   ($x, $y) = translate_point(@F[1, 12, 7]);
} else {
($x, $y) = translate_point(@F[1, 10, 7]);
}
if (defined($opt_q)) {
if (/^\+/) {
$statement = undef;
$q_time_seg{$is_ack,$y} = $x;
};
$statement = "move $q_time_seg{$is_ack,$y} $y\ndraw $x $y\n"
if (/^\-/);
} else {
$statement = "$x $y\n";
};
if (defined($statement)) {
if ($plot_drops) {
if ($is_ecn) {
push(@pc, $statement);
};
} else {
                if ($is_ack) {
                    if ($is_ecn) {
                        push(@ac, $statement);
                    } else {
                        push(@a, $statement);
                    };
                    if ($is_echo) {
                        push(@ae, $statement);
                    };
                } else {
                    if ($is_ecn) {
                        push(@pc, $statement);
                        } else {
                            push(@p, $statement);
                    };
                    if ($is_cong) {
                        push(@pg, $statement);
                        }
                };
};
};
next;
    };
    /^d / && do {
($x, $y) = translate_point(@F[1, 10, 7]);
push(@d, "$x $y\n");
next;
    };
    /link-down/ &&	(push(@ld, $F[1]), next);
    /link-up/ &&	(push(@lu, $F[1]), next);
    if ($plot_event) {
/^E / && do {
($x, $y) = translate_point(@F[1, 7, 6]);
if ($F[5] eq 'TCP_TIMEOUT') {
push(@vto, "$x $y\n");
next;
}
if ($F[5] eq 'SLOW_START') {
push(@vss, "$x $y\n");
next;
}
if ($F[5] eq 'FAST_RETX') {
push(@vfr, "$x $y\n");
next;
}
if ($F[5] eq 'RENO_FAST_RETX') {
push(@vrfr, "$x $y\n");
next;
}
if ($F[5] eq 'NEWRENO_FAST_RETX') {
push(@vnrfr, "$x $y\n");
next;
}
if ($F[5] eq 'FAST_RECOVERY') {
push(@vfc, "$x $y\n");
next;
}
};
    }
}	

if ($file eq '') {
($file) = ($dfile =~ m!([^/]+)$!);
}

if (!$no_title) {
    $title = defined($opt_t) ? $opt_t : $file;
    print "TitleText: $title\n" .
        "Device: Postscript\n" .
        "BoundBox: true\n" .
        "Ticks: true\n" .
        (defined($opt_q) ? "" : "NoLines: true\n") .
    
        "Markers: true\n" .
        "XUnitText: time\n" .
        "YUnitText: packets\n";
}

print "\n\"packets\n", @p;



if (defined($pc[0])) {
    @sorted_pc = sort (@pc);
    print "\n\"ecn_packets\n", @pc[0..3], @sorted_pc;
} else {
    if (!$no_padding) {
        printf "\n\"skip-1\n0 1\n";
    }
}

# insert dummy data sets so we get X's for marks in data-set 4
if (!$really_no_padding && !defined($a[0])) {
    push(@a, "0 1\n");
}
if ($plot_acks) {
    @sorted_a = sort (@a);
    print "\n\"acks\n", @sorted_a;
    if ($plot_ecn && defined($ac[0])) {
@sorted_ac = sort (@ac);
print "\n\"ecn-acks\n", @sorted_ac;
    }
    if ($plot_ecn && defined($ae[0])) {
@sorted_ae = sort (@ae);
print "\n\"echo-acks\n", @sorted_ae;
    }
} else {
    if (!$no_padding) {
        printf "\n\"skip-2\n0 1\n";
    }
}

#
# Repeat the first line twice in the drops file because often we have only
# one drop and xgraph won't print marks for data sets with only one point.
#
@sorted_d = sort (@d);
print "\n\"drops\n", @d[0..3], @sorted_d;

if ($plot_event) {
# Event tracing
    print "\n\"events\n";
    @sorted_vto = sort (@vto);
    print "\n\"event_timeout\n", @vto[0..3], @sorted_vto;
    @sorted_vss = sort (@vss);
    print "\n\"event_slowstart\n", @vss[0..3], @sorted_vss;
    @sorted_vfr = sort (@vfr);
    print "\n\"event_fastretx\n", @vfr[0..3], @sorted_vfr;
    @sorted_vrfr = sort (@vrfr);
    print "\n\"event_renofastretx\n", @vrfr[0..3], @sorted_vrfr;
    @sorted_vnrfr = sort (@vnrfr);
    print "\n\"event_nrenofastretx\n", @vnrfr[0..3], @sorted_vnrfr;
    @sorted_vfc = sort (@vfc);
    print "\n\"event_fastrecovery\n", @vfc[0..3], @sorted_vfc;
}



$c++;
print "\n";
foreach $i (@ld) {
print "\"link-down\n$i 0\n$i $c\n";
}
foreach $i (@lu) {
print "\"link-up\n$i 0\n$i $c\n";
}

if ($plot_ecn && defined($pg[0])) {
    if (!$really_no_padding && !defined($d[0])) {
printf "\n\"skip-3\n0 1\n";
    }
    @sorted_pg = sort (@pg);
    print "\n\"cong_act_packets\n", @pg[0..3], @sorted_pg;
}

if ($last_line) {
    # To bring the y-axis up to 2.0
    if (!$plot_full) {
        printf "\n\"skip\n0 2\n";
    } else {
        printf "\n\"skip\n0 1024\n";
    }
}

exit 0; 
