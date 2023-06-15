#!/usr/bin/perl -w
#

my @names = ();
my @nodes = ();

open(NAME, "taxonomy/names.dmp");
open(NODE, "taxonomy/nodes.dmp");
while( <NAME> ) {
	chomp;
	s/\t//g;
	my @d = split /\|/;
	push @names, \@d;
}
while( <NODE> ) {
	chomp;
	s/\t//g;
	my @d = split /\|/;
	push @nodes, \@d;
}
close(NAME);
close(NODE);

for( my $i=0; $i<10; $i++ ) {
	print STDERR join( " ", @{$names[$i]} ), "\n";
}

for( my $i=0; $i<10; $i++ ) {
	print STDERR join( " ", @{$nodes[$i]} ), "\n";
}

open(D, ">mothur.taxids.txt");
my @tids = ();
$tids[0] = 1;
open(T, ">mothur.taxonomy.txt");
my @taxa = ();
$taxa[0] = $names[0]->[1];
print T 1, "\t", $taxa[0], ";\n";
print D 1, "\t", $tids[0], ";\n";
for( my $i=1; $i<scalar(@names); $i++ ) {
	unless( $i == $names[$i]->[0]-1 ) {
		die "names mismatch: $i $names[$i]->[0]";
	}
	unless( $i == $nodes[$i]->[0]-1 ) {
		die "nodes mismatch: $i $nodes[$i]->[0]";
	}
	my $rn = $nodes[$i]->[1]-1;
	if( $rn == 0 ) {
		$taxa[$i] = $names[$i]->[1];
		$tids[$i] = $nodes[$i]->[0];
	} else {
		$taxa[$i] = $taxa[$rn] . ';' . $names[$i]->[1];
		$tids[$i] = $tids[$rn] . ';' . $nodes[$i]->[0];
	}
	print STDERR $i+1, ' ', $taxa[$i], "\n" if $i < 10;
	print STDERR $i+1, ' ', $tids[$i], "\n" if $i < 10;
	print T $i+1, "\t", $taxa[$i], ";\n";
	print D $i+1, "\t", $tids[$i], ";\n";
}
close(T);
close(D);
