#!/usr/bin/env perl
#
# Some fastq files have duplicated reads
# Remove the duplicated reads by comparing read names
# Keep the first comers

my $inFile = shift || die "Usage: $0 FASTQ-file-name\n";
my $outFile = $inFile;
$outFile =~ s/.fastq.gz$/.deDupl.fastq.gz/;

my $nin = 0;
my $nout  = 0;
my $n4 = 0;
my %names = ();

open(I, "zcat $inFile |");
open(O, "| gzip > $outFile");
my @buf = ();
my @h = ();
while( <I> ) {
	$nin++;
	$buf[$n4] = $_;
	if( $n4 == 0 ) {
		@h = split / /, $buf[$n4];
	}
	$n4++;
	if( $n4 == 4 ) {
		if( defined $names{$h[0]} ) {
			$names{$h[0]}++;
		} else {
			print O join('', @buf);
			$nout += 4;
			$names{$h[0]} = 1;
		}
		$n4 = 0;
	}
}
close(I);
close(O);
print STDERR $nin, " lines processed from $inFile\n";
print STDERR $nout, " lines written to $outFile\n";
print STDERR scalar( keys %names ), " unique reads\n";
if( $nin == $nout ) {
	print STDERR $inFile, " and ", $outFile, " have the same number of reads, the latter not saved\n";
	unlink($outFile);
} else {
	print STDERR $nin/$nout, " times duplicated\n";
	my $duplFile = $inFile . '.duplicate';
	rename( $inFile, $duplFile );
	rename( $outFile, $inFile );
	print STDERR $inFile, " is saved as ", $duplFile, "\n";
	print STDERR $inFile, " now contains only unique reads\n";
}
print STDERR "\n"
