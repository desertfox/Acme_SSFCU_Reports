package Acme::SSFCU::Report::History::Transaction::Factory;

use strict;
use warnings;

use Carp;
use DateTime;
use Text::CSV qw|csv|;
use Math::Currency;

use aliased 'Acme::SSFCU::Report::History::Transaction';

sub build_transaction_from_csv_line_array {
    my $class      = shift;
    my $line_array = shift;

    my ( $month, $day, $year ) = split( '/', $line_array->[0] );

    my $debit_amount  = Math::Currency->new( $line_array->[3] );
    my $credit_amount = Math::Currency->new( $line_array->[4] );

    my $amount = $debit_amount > 0 ? $debit_amount * -1 : $credit_amount;

    return Transaction->new(
        date => DateTime->new( year => $year, month => $month, day => $day ),
        check_number => $line_array->[1],
        description  => $line_array->[2],
        amount       => $amount,
    );
}

sub build_transactions_from_ssfcu_csv_file {
    my $class = shift;
    my $file  = shift;

    croak "Unable to find file" unless -f $file;

    my $lines  = csv( in => $file );
    my @titles = shift @{$lines};

    my @transactions
        = map { $class->build_transaction_from_csv_line_array($_) }
        @{$lines};

    croak "Unable to find transactions" unless @transactions;

    return \@transactions;
}
1;
