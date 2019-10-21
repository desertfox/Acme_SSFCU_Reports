package Acme::SSFCU::Reports::Output;

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

has history => (
    is  => 'ro',
    isa => sub {
        croak "Must pass SSFCU::Reports::History obj"
            unless ref $_[0] eq 'Acme::SSFCU::Reports::History';
    }
);

has drivers => ( is => 'ro' );
has streams => ( is => 'ro' );    #stdout/email/csv etc

sub execute {
    my $self = shift;

    my $OUTPUT = {};              #String output buffer
    foreach my $report ( keys %{ $self->drivers } ) {

        next unless $self->drivers->{$report};

        my $REPORT_CLASS = sprintf qq|Acme::SSFCU::Reports::Output::%s|,
            $report;

        load_class($REPORT_CLASS);

        $OUTPUT->{$report} = $REPORT_CLASS->calculate( $self->history );

    }

    return $OUTPUT;
}

1;
