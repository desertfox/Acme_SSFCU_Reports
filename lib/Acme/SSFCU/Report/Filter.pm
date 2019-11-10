package Acme::SSFCU::Report::Filter;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use aliased 'Acme::SSFCU::Report::Filter::Iterator';

has filters  => ( is => 'rw', default => sub { return []; } );
has iterator => (
    is      => 'rw',
    default => sub { Iterator->new( _filter => shift ); },
    handles => [qw|add_filter|]
);

sub generate_report_data {
    my $self    = shift;
    my $history = shift;

    my @results;
    while ( !$self->iterator->is_done() ) {
        push( @results, $self->iterator->get_filter()->calculate($history) )
            && $self->iterator->next;
    }

    return \@results;
}

1;
