package Acme::SSFCU::Report::Filter::Iterator;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

has _index  => ( is => 'rw', default => 0 );
has _filter => (
    is  => 'rw',
    isa => sub {
        croak "Incorrect _filter Type: " . ref $_[0]
            unless ref $_[0] eq 'Acme::SSFCU::Report::Filter';
        },
        handles => { "filters" => "filters" }

);

sub is_done {
    my $self = shift;

    return ( $self->_index >= $self->get_count() && $self->reset_index );
}

sub next {
    my $self = shift;

    return $self->{_index}++;
}

sub get_filter {
    my $self = shift;

    my $filter = sprintf qq|Acme::SSFCU::Report::Filter::%s|,
        $self->filters->[ $self->_index ];

    load_class($filter);

    return $filter;
}

sub reset_index {
    my $self = shift;

    $self->{_index} = 0;

    return 1;
}

sub add_filter {
    my $self   = shift;
    my $filter = shift;

    push( @{ $self->filters() }, $filter );

    return;
}

sub get_count {
    my $self = shift;

    return scalar @{ $self->filters };
}

1;
