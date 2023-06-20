#!/usr/bin/env perl
# Read in ASN.CM.MGD from STDIN
# Create consensus sequence per taxid to STDOUT
#

my @bases = ( 'A', 'C', 'G', 'T' );
my $n = 0;
while( <> ) {
	$n++;
	chomp;
	my ($tid, $total, @arr) = split;
	my $d = 0;
	my $j = 0;
	my $k = 0;
	my $m = 0;
	my @s = ();
	for( my $i=0; $i<scalar(@arr); $i++ ) {
		if( $arr[$i] > $m ) {
			$m = $arr[$i];
			$k = $j;
		}
		$j++;
		if( $j == 4 ) {
			if( $m == 0 ) {
				push @s, '-';
				$d++;
			} else {
				push @s, $bases[$k];
			}
			$j = 0;
			$k = 0;
			$m = 0;
		}
	}
	print ">$tid abundance $total dashes $d\n";
	print join('', @s), "\n";
	print STDERR "$n lines processed\n" if $n % 1000 ==  0;
}
print STDERR "Total $n lines\n";
