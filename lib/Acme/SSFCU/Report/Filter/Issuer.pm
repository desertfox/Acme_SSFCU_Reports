package Acme::SSFCU::Report::Filter::Issuer;

use strict;
use warnings;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my %per_descriptions;
    foreach my $trxn ( @{ $history->transactions } ) {
        my $description = $trxn->description;
        $description =~ s/\d{2}\/\d{2}\s+?//;   #Remove dates to help condense
        $per_descriptions{$description} += $trxn->amount;
    }

    my @sorted_desc = sort { $per_descriptions{$b} <=> $per_descriptions{$a} }
        keys %per_descriptions;

    my @data;
    foreach my $description (@sorted_desc) {
        push( @data, [ $description, $per_descriptions{$description} ] );
    }

    return {
        filter_name => $class,
        filter_data => {
            title => qq|Description: %s, Total: %s|,
            data  => \@data,
        }
    };
}

1;
