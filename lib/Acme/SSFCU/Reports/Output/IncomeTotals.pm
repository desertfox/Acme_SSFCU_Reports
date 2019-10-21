package Acme::SSFCU::Reports::Output::IncomeTotals;

use strict;
use warnings;

use Math::Currency;

use base 'Acme::SSFCU::Reports::Output::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my $total_income = Math::Currency->new('0.00');
    foreach my $trxn ( @{ $history->transactions } ) {
        next unless $trxn->credit_amount;
        $total_income += $trxn->credit_amount;
    }

    return __PACKAGE__ . " " . $total_income->as_float;
}

1;
