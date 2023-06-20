#!/usr/bin/env perl
#
# Read in RNA 2nd structure in dot-bracket notation
# write out positional data frame (1-based)
#

my $cs = <>;
chomp $cs;
my $ss = <>;
chomp $ss;
my @a = split(/ /,$ss);	# remove the trailing energy term
$ss = $a[0];
print STDERR substr($cs,0,5), ' ... ', substr($cs,-5), "\n";
print STDERR substr($ss,0,5), ' ... ', substr($ss,-5), "\n";

my @cs = split(//, $cs);
my @ss = split(//, $ss);
my @ct = ();
my @open = ();
for( my $i=0; $i<scalar(@ss); $i++ ) {
	if( $ss[$i] eq '.' ) {
		next;
	} elsif( $ss[$i] eq '(' ) {
		push @ct, [$i+1,$cs[$i],'',0];
		push @open, $#ct;
	} elsif( $ss[$i] eq ')' ) {
		my $n = pop @open;
		$ct[$n]->[2] = $cs[$i];
		$ct[$n]->[3] = $i+1;
	} elsif( $ss[$i] eq ' ' ) {
		last;
	}
}

for( my $j=0; $j<scalar(@ct); $j++ ) {
	print join("\t", @{$ct[$j]}), "\n";
}
