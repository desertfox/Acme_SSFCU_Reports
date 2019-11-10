package Acme::SSFCU::Report::History;

#ABSTRACT: Module for generating various reports via SSFCU downloaded csv transaction histroy files.
use strict;
use warnings;

use Moo;
use namespace::autoclean;

use aliased 'Acme::SSFCU::Report::History::Iterator';

has transactions => (
    is      => 'rw',
    default => sub { return []; },
);

has iterator => (
    is      => 'rw',
    default => sub { return Iterator->new( _history => shift ) },
    handles => [qw|add_source add_transaction get_count|],
);

1;
