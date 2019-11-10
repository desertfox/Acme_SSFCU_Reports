package Acme::SSFCU::Report::Filter;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

use Moo;
use namespace::autoclean;

use aliased 'Acme::SSFCU::Report::Filter::Iterator';

has filters => ( is => 'rw' );
has iterator =>
    ( is => 'rw', default => sub { Iterator->new( _filter => shift ); } );

sub generate_report_data {
    my $self    = shift;
    my $history = shift;

    my @results;
    while ( !$self->iterator->is_done() ) {
        my $item = $self->iterator->item();
        push( @results, $item->calculate($history) );
        $self->iterator->next;
    }

    return \@results;
}

sub get_count {
    my $self = shift;

    return scalar @{ $self->{filters} };
}

1;
