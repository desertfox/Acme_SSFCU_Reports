package Acme::SSFCU::Report::Filter::Losses;

use strict;
use warnings;

use Math::Currency;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my $total_income = Math::Currency->new('0.00');

    my $history_iterator = $history->iterator;
    while ( !$history_iterator->is_done() ) {
        if ( $history_iterator->get_transaction()->amount > 0 ) {
            $history_iterator->next;
            next;
        }
        $total_income += $history_iterator->get_transaction()->amount;
        $history_iterator->next;
    }

    return {
        filter_name => $class,
        filter_data => {
            title => qq|Total: %s|,
            data  => [$total_income],
        }
    };
}

1;
