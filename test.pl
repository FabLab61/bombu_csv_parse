#!/usr/bin/perl
use strict;
use Tie::File;
use Data::Dumper;

my $file = "bom-lasersaur-v14.03.csv";
tie my @file, 'Tie::File', $file or die $!;
my $hash = {};
my @arr = [];
my $item_strings = 0;

for my $linenr (0 .. $#file) {
	if ($file[$linenr] =~ /^\w+\s/ ) {
		my @a = split (/   /, $file[$linenr]);
		$hash->{'item'} = @a[0];
		$hash->{'supplier'} = @a[1];
		$hash->{'order_num'} = @a[2];
		my $i=0;
		for($i = 3; $i < scalar @a; $i++) {
			my $a = 1;
			# if ( @a[$i] =~ /^([A-Z]{3}\s[0-9]+)\s / ) {
				my @b = split (/ /, @a[$i]);
			 	$hash->{'currency_'.$a}=@b[0];
			 	$hash->{'price_'.$a}=@b[1];
			 	$hash->{'url_'.$a}=@b[2];
			 	$a++;
			 # }
		
		}
			
		my @c = split (/   /, $file[$linenr+1]);
		$hash->{'total_num'} = @c[1];
		$hash->{'num'} = @c[1];


		push @arr, $hash;
		$hash={};
	}
}
untie @file;

warn Dumper @arr;