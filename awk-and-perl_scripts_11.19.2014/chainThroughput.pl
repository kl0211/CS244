$indst = $ARGV[0];

$infile="./chain.tr";

$simtime=30.0;

open (DATA, "<$infile")
	|| die "Can't open $infile $!";

$totalBytes = 0;


while (<DATA>) {
	@x = split(' ');
	next if $x[3] ne "AGT"; # Why not MAC? What additional filter is required in that case?
	next if $x[6] ne "tcp";
	next if $x[0] ne "r";
	
	if ($x[7] > 200) {
		$totalBytes += $x[7];
	}
}

$thpt = ($totalBytes*8)/$simtime; 
print "$indst\t$thpt\n";

exit(0);
			
