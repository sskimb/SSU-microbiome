#!/usr/bin/env perl

my $message = <<EOD;
 Merging all *.asn.cm files in the folder
 Creating one line per taxid on STDOUT (recommended name: *.ASN.CM.MGD)
 which can be processed by hmmufotu-asn.cm.cs.pl to create consensus fasta file
 also mothur style count_table is saved
EOD
print STDERR $message;

my @cms = glob("*.asn.cm");
print STDERR scalar( @cms ), " files found\n";

my $mgd;
my $cnt;
my %cms;
foreach my $cm ( @cms ) {
	open(C, $cm) || die "Unable to open $cm\n";
	print STDERR "Processing $cm";
	$cms = $cm;
	$cms =~ s/.asn.cm//;
	unless( defined $cms{$cms} ) { $cms{$cms} = 1 }
	my $n = 0;
	while( <C> ) {
		$n++;
		chomp;
		my ($tid, @arr) = split;
		if( defined $mgd->{$tid} ) {
			for( my $j=0; $j<scalar(@arr); $j++ ) {
				$mgd->{$tid}->[$j] += $arr[$j];
			}
		} else {
			for( my $j=0; $j<scalar(@arr); $j++ ) {
				$mgd->{$tid}->[$j] = $arr[$j];
			}
		}
		$cnt->{$tid}->{$cms} = $arr[0];
	}
	print STDERR "...$n lines\n";
	close(C);
}

foreach my $tid ( sort { $a <=> $b } keys %$mgd ) {
	print join( ' ', $tid, @{$mgd->{$tid}} ), "\n";
}

open(O, ">count_table");
my @cmsSort = sort { $a cmp $b } keys %cms;
my @cntSort = sort { $a <=> $b } keys %$cnt;
print O join("\t", "Representative_sequence\ttotal", @cmsSort), "\n";
foreach my $tid (@cntSort) {
	my $ct = $cnt->{$tid};
	print O $tid, "\t", $mgd->{$tid}->[0];
	foreach my $cms (@cmsSort) {
		print O "\t", $ct->{$cms} || 0;
	}
	print O "\n";
}
close(O);
print STDERR scalar(@cntSort), " OTUs for ", scalar(@cmsSort), " samples\n";
print STDERR "Mothur's style count_table has been saved\n";
