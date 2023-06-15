#!/usr/bin/env perl
#
# Split recordes by '//'
#

$/ = "//\n";

my $nr = 0;
while( <> ) {
	$nr++;
	open(O, ">$nr.blk");
	print O $_;
	close(O);
}
print STDERR $nr, " records split\n";
