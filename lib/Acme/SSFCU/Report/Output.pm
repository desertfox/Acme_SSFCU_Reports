package Acme::SSFCU::Report::Output;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

use Acme::SSFCU::Report::Stream::Print;

sub generate_output {
    my $self                      = shift;
    my $filtered_report_data_aref = shift;

    my $STREAM
        = Acme::SSFCU::Report::Output::Stream::Print->new(
        handle => *STDOUT );

    $STREAM->execute($_) foreach @$filtered_report_data_aref;

    return;
}

1;
