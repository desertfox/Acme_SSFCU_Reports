package Acme::SSFCU::Report::Filter::DateNetProfit;

use strict;
use warnings;

use base 'Acme::SSFCU::Report::Filter::Driver';

sub calculate {
    my $class   = shift;
    my $history = shift;

    my %per_day_totals;
    my $history_iterator = $history->iterator;
    while ( !$history_iterator->is_done() ) {
        my $item = $history_iterator->item();

        if ( exists $per_day_totals{ $item->date->ymd } ) {
            $per_day_totals{ $item->date->ymd }{amount} += $item->amount;
        }
        else {
            $per_day_totals{ $item->date->ymd } = {
                date   => $item->date,
                amount => $item->amount,
            };
        }

        $history_iterator->next;
    }

    my @sorted_by_date_totals
        = sort { $per_day_totals{$b}{date} <=> $per_day_totals{$a}{date} }
        keys %per_day_totals;

    my @data;
    foreach my $date (@sorted_by_date_totals) {
        push(
            @data,
            [   $per_day_totals{$date}{date}->ymd,
                "$per_day_totals{$date}{amount}"
            ]
        );
    }

    return {
        filter_name => $class,
        filter_data => {
            title => qq|Date: %s, Total: %s|,
            data  => \@data,
        }
    };
}

1;

__END__
    my $output;
    foreach my $date (@sorted_by_date_totals) {
        $output .= sprintf(
            qq|Date: %s, Total: %s|,
            $per_day_totals{$date}{date}->ymd,
            $per_day_totals{$date}{amount}
        ) . "\n";
    }

    return $class . "\n" . $output;
