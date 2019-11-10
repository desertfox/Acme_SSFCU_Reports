package Acme::SSFCU::Report::Output;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use Carp;
use Acme::SSFCU::Report::Stream::Print;

has history => ( is => 'rw' );

has filter => ( is => 'rw' );

has data => (
    is   => 'rw',
    lazy => 1,
    isa =>
        sub { croak "Filter must be arrayRef" unless ref $_[0] eq "ARRAY" },
    builder => '_build_data'
);

sub _build_data {
    my $self = shift;

    return $self->filter->generate_report_data( $self->history );
}

sub generate_output {
    my $self = shift;

    my $STREAM
        = Acme::SSFCU::Report::Output::Stream::Print->new(
        handle => *STDOUT );

    $STREAM->execute($_) foreach @{ $self->data };

    return;
}

1;
