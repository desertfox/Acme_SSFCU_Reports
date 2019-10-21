package Acme::SSFCU::Reports::Transaction;

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

has $_ => (
    is  => 'ro',
    isa => sub {
        ref $_[0] eq 'Math::Currency'
            or croak $_ . ' , must be of type Math::Currency';
    }
) foreach qw/debit_amount credit_amount/;

sub build_from_csv_line_array {
    my $class      = shift;
    my $line_array = shift;

    my($month, $day, $year) = split('/', $line_array->[0]);

    return $class->new(
        date          => DateTime->new( year => $year , month => $month, day => $day ),
        check_number  => $line_array->[1],
        description   => $line_array->[2],
        debit_amount  => Math::Currency->new( $line_array->[3] ),
        credit_amount => Math::Currency->new( $line_array->[4] )
    );
}

1;
