package Acme::SSFCU::Report::Filter::NetProfit;

use strict;
use warnings;

use Math::Currency;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my $total_income = Math::Currency->new('0.00');
    foreach my $trxn ( @{ $history->transactions } ) {
        next unless $trxn->amount;
        $total_income += $trxn->amount;
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
