package Acme::SSFCU::Report;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use aliased 'Acme::SSFCU::Report::Output';
use aliased 'Acme::SSFCU::Report::Filter';
use aliased 'Acme::SSFCU::Report::History';

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

has history => ( is => 'ro', required => 1 );
has filter  => ( is => 'ro', required => 1 );
has output  => ( is => 'ro', default  => sub { Output->new(); } );

around BUILDARGS => sub {
    my ( $orig, $class, %args ) = @_;

    my $source = delete $args{source};
    $args{history} ||= History->new( csv_file => $source->{csv_file} )
        if $source->{csv_file};

    my $filters = delete $args{filters};
    $args{filter} ||= Filter->new( filters => $filters ) if scalar @$filters;

    my $output = delete $args{output};
    $args{output} ||= Output->new( destination => $output );

    return $class->$orig(%args);
};

sub run {
    my $self = shift;

    my $filter_array_ref = $self->filter->apply_filter( $self->history );

    return $self->output->execute($filter_array_ref);
}

1;
