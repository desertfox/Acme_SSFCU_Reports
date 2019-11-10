package Acme::SSFCU::Report::History::Factory;

use strict;
use warnings;

use Carp;
use Text::CSV qw|csv|;

use aliased 'Acme::SSFCU::Report::History';
use aliased 'Acme::SSFCU::Report::History::Transaction::Factory' =>
    'Transaction_Factory';

sub build_history_from_ssfcu_csv_file {
    my $class = shift;
    my $file  = shift;

    croak "Unable to find file" unless -f $file;

    my $lines  = csv( in => $file );
    my @titles = shift @{$lines};

    my @transactions
        = map { Transaction_Factory->build_transaction_from_csv_line_array($_) }
        @{$lines};

    croak "Unable to find transactions" unless @transactions;

    return History->new( transactions => \@transactions );
}

1;
