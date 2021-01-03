package Acme::SSFCU::Report::Filter::Issuer;

use strict;
use warnings;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my %per_descriptions;
    my $history_iterator = $history->iterator;
    while ( !$history_iterator->is_done() ) {
        my $description = $history_iterator->get_transaction()->description;
        $description =~ s/\W|\d//g; #remove fluff in an attempt to make consolidation easier. 
        $description = 'Amazon Marketplace' if $description =~ m/^AMZN.*/;
        $per_descriptions{$description} += $history_iterator->get_transaction()->amount;
        $history_iterator->next;
    }

    my @sorted_desc = sort { $per_descriptions{$a} <=> $per_descriptions{$b} }
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
