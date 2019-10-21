package Acme::SSFCU::Reports::Output;

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

use Acme::SSFCU::Reports::Output::Streams::Print;

has history => (
    is  => 'ro',
    isa => sub {
        croak "Must pass SSFCU::Reports::History obj"
            unless ref $_[0] eq 'Acme::SSFCU::Reports::History';
    }
);

has drivers       => ( is => 'ro' );
has output_buffer => ( is => 'ro', default => sub { return {}; } );

sub execute {
    my $self = shift;

    foreach my $report ( keys %{ $self->drivers } ) {

        next unless $self->drivers->{$report};

        my $REPORT_CLASS
            = sprintf( qq|Acme::SSFCU::Reports::Output::%s|, $report );

        load_class($REPORT_CLASS);

        $self->output_buffer->{$report}
            = $REPORT_CLASS->calculate( $self->history );

    }

    my $STREAM
        = Acme::SSFCU::Reports::Output::Streams::Print->new(
        handle => *STDOUT );

    foreach my $output_driver ( keys %{ $self->output_buffer } ) {
        $STREAM->execute( $self->output_buffer->{$output_driver} );
    }

    return;
}

1;
