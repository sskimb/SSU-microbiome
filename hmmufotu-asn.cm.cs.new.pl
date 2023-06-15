#!/usr/bin/env perl
# Read in ASN.CM.MGD from STDIN
# Create consensus sequence per taxid to STDOUT
#
#              0    1    2    3    4    5    6    7    8    9   10   11   12   13   14   15
#              -    A    C   AC    G   AG   CG   ACG   T   AT   CT   ACT  GT   AGT  CGT  ACGT
my @bases = ( '-', 'A', 'C', 'M', 'G', 'R', 'S', 'V', 'T', 'W', 'Y', 'H', 'K', 'D', 'B', 'N' );
my @bits = ( 1, 2, 4, 8 );
my $n = 0;
while( <> ) {
	$n++;
	chomp;
	my ($tid, $total, @arr) = split;
	my $cutoff = int($total*0.2);	# normally 0.25, but allow some uncertainty
	$cutoff = 1 if $cutoff == 0;	# minimum 1
	my $half = int($total*.05);
	$half = 1 if $half == 0;
	my $d = 0;
	my $j = 0;
	my $k = 0;
	my $m = 0;
	my @s = ();
	for( my $i=0; $i<scalar(@arr); $i+=4 ) {
		$m = 0;
		for( my $j=0; $j<4; $j++ ) {
			if( $arr[$i+$j] >= $half ) {
				$m = $bits[$j];
				last;	# prob > 0.5 found, no further check necessary
			} elsif( $arr[$i+$j] >= $cutoff ) {
				$m += $bits[$j];
			}
		}
		push @s, $bases[$m];
		$d++ if $m == 0;
	}
	print ">$tid abundance $total dashes $d\n";
	print join('', @s), "\n";
	print STDERR "$n lines processed\n" if $n % 1000 ==  0;
}
print STDERR "Total $n lines\n";
