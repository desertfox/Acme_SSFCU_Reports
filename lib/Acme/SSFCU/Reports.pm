package Acme::SSFCU::Reports;

use strict;
use warnings;

use DDP;
use Carp;

use Acme::SSFCU::Reports::Output;
use Acme::SSFCU::Reports::History;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.

sub run {
    my $class = shift;
    my %args  = ref $_[0] eq 'HASH' && @_ == 1 ? %{ $_[0] } : @_;

    return Acme::SSFCU::Reports::Output->new(
        history =>
            Acme::SSFCU::Reports::History->new( csv_file => $args{csv_file} ),
        drivers => $args{opts}->{drivers},
    )->execute();

}

1;
