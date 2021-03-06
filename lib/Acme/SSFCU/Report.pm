package Acme::SSFCU::Report;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use Carp;

use aliased 'Acme::SSFCU::Report::Output';
use aliased 'Acme::SSFCU::Report::Filter';
use aliased 'Acme::SSFCU::Report::History';

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

has filter_list => (
    is => 'rw',
    isa =>
        sub { croak "Filter must be arrayRef" unless ref $_[0] eq "ARRAY" },
    required => 1
);

has sources => (
    is => 'rw',
    isa =>
        sub { croak "Filter must be arrayRef" unless ref $_[0] eq "ARRAY" },
    required => 1
);

has history => (
    is      => 'ro',
    default => sub { return History->new; },
    handles => [qw|add_source|]
);

has filter => (
    is      => 'ro',
    default => sub { return Filter->new; },
    handles => [qw|add_filter|]
);

has output => (
    is      => 'rw',
    lazer   => 1,
    builder => '_build_output',
    handles => [qw|generate_output|]
);

sub _build_output {
    my $self = shift;

    return Output->new( filter => $self->filter, history => $self->history );
}

sub BUILD {
    my $self = shift;

    $self->add_source($_) foreach @{ $self->sources };

    $self->add_filter($_) foreach @{ $self->filter_list };

    $self->generate_output();

    return $self;
}

sub run {
    return shift->new(@_);
}

1;
