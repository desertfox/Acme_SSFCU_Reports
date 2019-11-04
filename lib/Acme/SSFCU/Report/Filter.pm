package Acme::SSFCU::Report::Filter;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

has filters => ( is => 'rw' );

sub generate_report_data {
    my $self    = shift;
    my $history = shift;

    my @results;
    foreach my $filter_hash ( @{ $self->filters } ) {
        my $filter_name = ( keys %$filter_hash )[0];

        next
            unless $filter_hash->{$filter_name};

        my $filter = __PACKAGE__ . '::' . $filter_name;

        load_class($filter);

        push( @results, $filter->calculate($history) );

    }

    return \@results;
}

1;
