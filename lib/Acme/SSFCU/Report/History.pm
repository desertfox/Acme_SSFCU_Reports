package Acme::SSFCU::Report::History;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

use Moo;
use namespace::autoclean;

use Carp;
use Text::CSV qw|csv|;
use Math::Currency;

use aliased 'Acme::SSFCU::Report::History::Transaction';

has csv_file     => ( is => 'ro' );
has transactions => ( is => 'ro', required => 1 );

around BUILDARGS => sub {
    my ( $orig, $class, %args ) = @_;

    $args{transactions} ||= parse_ssfcu_csv_file( $args{csv_file} );

    return $class->$orig(%args);
};

sub parse_ssfcu_csv_file {
    my $file = shift;

    croak "Unable to find file" unless -f $file;

    my $lines  = csv( in => $file );
    my @titles = shift @{$lines};

    my @transactions
        = map { Transaction->build_from_csv_line_array($_) } @{$lines};

    croak "Unable to find transactions" unless @transactions;

    return \@transactions;
}

1;
