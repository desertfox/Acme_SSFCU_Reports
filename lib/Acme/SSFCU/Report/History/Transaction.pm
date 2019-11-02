package Acme::SSFCU::Report::History::Transaction;

use Moo;
use namespace::autoclean;

use Carp;
use DateTime;

has date => (
    is  => 'ro',
    isa => sub {
        ref $_[0] eq 'DateTime' or croak 'date, must be of type DateTime';
    }
);

has $_ => ( is => 'ro' ) foreach qw/check_number description/;

has amount => (
    is  => 'ro',
    isa => sub {
        ref $_[0] eq 'Math::Currency'
            or croak 'amount, must be of type Math::Currency';
    }
);

sub build_from_csv_line_array {
    my $class      = shift;
    my $line_array = shift;

    my ( $month, $day, $year ) = split( '/', $line_array->[0] );

    my $debit_amount  = Math::Currency->new( $line_array->[3] );
    my $credit_amount = Math::Currency->new( $line_array->[4] );

    my $ZERO = Math::Currency->new('0.00');

    my $amount = $debit_amount > $ZERO ? $debit_amount * -1 : $credit_amount;

    return $class->new(
        date => DateTime->new( year => $year, month => $month, day => $day ),
        check_number => $line_array->[1],
        description  => $line_array->[2],
        amount       => $amount,
    );
}

1;
