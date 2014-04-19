#!/usr/bin/perl
use strict;
use Tie::File;
use Data::Dumper;

my $file = "bom-lasersaur-v14.03.csv";
tie my @file, 'Tie::File', $file or die $!;
my $hash = {};
my @arr;
my $item_strings = 0;

for my $linenr (0 .. $#file) {
	if ($file[$linenr] =~ /^\w+\s/ ) {
		my @a = split (/   /, $file[$linenr]);
		$hash->{'item'} = @a[0];
		$hash->{'supplier'} = @a[1];
		$hash->{'order_num'} = @a[2];
		
		my @prices;
		for(my $i = 3; $i < scalar @a; $i++) {			# cycle for prices
			# if ( @a[$i] =~ /^([A-Z]{3}\s[0-9]+)\s / ) {
				my @b = split (/ /, @a[$i]);
				my $hash1 = {}; 	
			 	$hash1->{'currency'}=@b[0];
			 	$hash1->{'price'}=@b[1];
			 	$hash1->{'url'}=@b[2];
			 	push (@prices, $hash1);
			 # }
		}
		$hash->{'prices'} = \@prices;   



		my $j=1;
		my @usage;
		while ($file[$linenr+$j] =~ /^\s\s\s/) {
			my @c = split (/   /, $file[$linenr+$j]);
			my $hash2 = {};
			if ($c[1] =~ /^\d+\/\d+/) {
				my @numbers = split (/\//, $c[1]);
				$hash->{'total'} = @numbers[1];
				$hash2->{'qt'} = @numbers[0];
				} 
			else {
					$hash->{'total'} = $c[1];
				}
		    $hash2->{'subsystem'} = $c[2];
		    $hash2->{'use'} = $c[3];
		    push @usage, $hash2;
			$j++;
		}
		$hash->{'usage'} = \@usage;

		push @arr, $hash;
		$hash={};
		
	}
}
untie @file;

warn Dumper @arr[0];