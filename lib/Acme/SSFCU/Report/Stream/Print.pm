package Acme::SSFCU::Report::Output::Stream::Print;

use strict;
use warnings;

# ABSTRACT: This is the base class for other Driver modules
use Moo;
use namespace::autoclean;

has handle => ( is => 'ro' );

sub execute {
    my $self        = shift;
    my $filter_data = shift;

    my $NL     = "\n";
    my $output = $filter_data->{filter_name} . $NL;

    foreach my $filter_data_href ( @{$filter_data}{filter_data} ) {
        my $template = $filter_data_href->{title};

        foreach my $deep_data ( @{ $filter_data_href->{data} } ) {
            $output .= sprintf( $template, ref $deep_data eq 'ARRAY' ? @{$deep_data} : $deep_data ) . $NL;
        }

        $output .= $NL;
    }

    my $fake_fh = $self->handle;

    print $fake_fh $output;

    return;
}

1;
