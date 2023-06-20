#!/usr/bin/env perl
#
# Input: fasta file with sequence name as simple integer
# Output: fasta file with sequence name prefixed with 'UFOtu' and 6-digit padding

my $ndgt = shift || 6;
print STDERR 'Prefix of UFOtu appended by 0-padded ', $ndgt, " number\n";

my $n = 0;
while( <> ) {
	if( /^>/ ) {
		my $id = substr($_, 1, index($_, ' ')-1);
		my $rid = sprintf('UFOtu%0' . $ndgt . 'd', $id);
		print STDERR $id, ' ', $rid, "\n" if $n < 10;
		s/>$id/>$rid/;
		$n++;
	}
	print;
}
print STDERR $n, " sequences processed\n";
