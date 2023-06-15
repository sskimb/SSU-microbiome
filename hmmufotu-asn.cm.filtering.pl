#!/usr/bin/env perl
#

my ($infile, $abdmin, $gapmax, $count) = @ARGV;
print STDERR $infile, "\n";
print STDERR $abdmin, " min abundance\n";
print STDERR $gapmax, " max gaps\n";
print STDERR $count, "\n";

my $outfile = $infile;
$outfile =~ s/.fasta/.pick.fasta/;

open(I, $infile);
open(O, ">$outfile");
my $skip = 0;
my $nin = 0;
my $nout = 0;
my $header;
my $fasta;
my @abd = ();
my @gap = ();
my %tid = ();
while( <I> ) {
	chomp;
	if( /^>/ ) {
		$nin++;
		my ($tid, $a, $abd, $g, $gap) = split / /;
		$tid =~ s/^>//;
		if( $abd < $abdmin || $gap > $gapmax ) {
			$skip = 1;
		} else {
			$skip = 0;
			push @abd, $abd;
			push @gap, $gap;
			$tid{$tid} = 1;
		}
		$header = $_;
	} else {
		$fasta = $_;
		unless( $skip == 1 ) {
			$nout++;
			print O $header, "\n";
			print O $fasta, "\n";
		}
	}
}
close(I);
close(O);

print STDERR $nin, " sequences in\n";
print STDERR $nout, " sequences saved in ", $outfile, "\n";

print STDERR "Abd: ", join(' ', summary( \@abd )), "\n";
print STDERR "Gap: ", join(' ', summary( \@gap )), "\n";
print STDERR scalar(keys %tid), " taxons\n";

open(C, $count);
open(D, ">pick.count_table");
my $line = <C>;
print D $line;
my $nc = 0;
while( <C> ) {
	my ($tid, @rest) = split /\t/;
	next unless defined $tid{$tid};
	print D join("\t", $tid, @rest);
	$nc++;
}
close(C);
close(D);
print STDERR $nc, " lines saved in pick.count_table\n";

sub summary {
	my $x = shift;
	my $s = 0;
	foreach my $t (@$x) {
		$s += $t;
	}
	$s /= scalar(@$x);
	my @x = sort { $a <=> $b } @$x;
	my $qt1 = $x[$#$x/4];
	my $qt2 = $x[$#$x/2];
	my $qt3 = $x[$#$x/1.333];
	return ($x[0], $qt1, $qt2, $qt3, $x[$#$x], $s);
}
