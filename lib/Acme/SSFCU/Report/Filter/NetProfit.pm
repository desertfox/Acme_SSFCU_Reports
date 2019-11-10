package Acme::SSFCU::Report::Filter::NetProfit;

use strict;
use warnings;

use Math::Currency;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my $total_income     = Math::Currency->new('0.00');
    my $history_iterator = $history->iterator;
    while ( !$history_iterator->is_done() ) {
        next unless $history_iterator->item()->amount;
        $total_income += $history_iterator->item()->amount;
        $history_iterator->next;
    }

    return {
        filter_name => $class,
        filter_data => {
            title => qq|Total: %s|,
            data  => ["$total_income"],
        }
    };
}

1;
