#!/usr/bin/env perl
# Merging all *.kreport2 files in the folder
# by picking 3rd column (count) and 5th column (taxid)
# mothur style count_table is saved (count_table)

my @cms = glob("*.kreport2");
print STDERR scalar( @cms ), " files found\n";

my $cnt;
my %cms;
foreach my $cm ( @cms ) {
	open(C, $cm) || die "Unable to open $cm\n";
	print STDERR "Processing $cm";
	$cms = $cm;
	$cms =~ s/.kreport2//;
	unless( defined $cms{$cms} ) { $cms{$cms} = 1 }
	my $n = 0;
	while( <C> ) {
		$n++;
		chomp;
		s/^\s+//;
		my @arr = split;
		my $tid = $arr[4];
		$cnt->{$tid}->{$cms} = $arr[2] if $arr[2] > 0;
	}
	print STDERR "...$n lines\n";
	close(C);
}

open(O, ">count_table");
my @cmsSort = sort { $a cmp $b } keys %cms;
my @cntSort = sort { $a <=> $b } keys %$cnt;
print O join("\t", "Representative_sequence\ttotal", @cmsSort), "\n";
foreach my $tid (@cntSort) {
	my $ct = $cnt->{$tid};
	my $total = 0;
	my @ct = ();
	foreach my $cms (@cmsSort) {
		my $t = $ct->{$cms} || 0;
		push @ct, $t; 
		$total += $t;
	}
	print O join("\t", $tid, $total, @ct), "\n";
}
close(O);
print STDERR scalar(@cntSort), " OTUs for ", scalar(@cmsSort), " samples\n";
print STDERR "Mothur's style count_table has been saved\n";
