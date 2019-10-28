package Acme::SSFCU::Report::Output;

use Moo;
use namespace::autoclean;

use Carp;
use Class::Load qw/load_class/;

use Acme::SSFCU::Report::Stream::Print;

sub execute {
    my $self          = shift;
    my $filtered_data = shift;

    my $STREAM
        = Acme::SSFCU::Report::Output::Stream::Print->new(
        handle => *STDOUT );

    $STREAM->execute($_) foreach @$filtered_data;

    return;
}

1;