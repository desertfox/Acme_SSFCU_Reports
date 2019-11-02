package Acme::SSFCU::Report::Filter::DateNetProfit;

use strict;
use warnings;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my @sorted_by_date = $history->sort_by_date();

    my %per_day_totals;
    foreach my $trxn (@sorted_by_date) {
        if ( exists $per_day_totals{ $trxn->date->ymd } ) {
            $per_day_totals{ $trxn->date->ymd }{amount} += $trxn->amount;
        }
        else {
            $per_day_totals{ $trxn->date->ymd } = {
                date   => $trxn->date,
                amount => $trxn->amount,
            };
        }
    }

    my @sorted_by_date_totals
        = sort { $per_day_totals{$b}{date} <=> $per_day_totals{$a}{date} }
        keys %per_day_totals;

    my $output;
    foreach my $date (@sorted_by_date_totals) {
        $output .= sprintf(
            qq|Date: %s, Total: %s|,
            $per_day_totals{$date}{date}->ymd,
            $per_day_totals{$date}{amount}
        ) . "\n";
    }

    return __PACKAGE__ . "\n" . $output;
}

1;
