package Acme::SSFCU::Report::History::Transaction;

use strict;
use warnings;

use Moo;
use namespace::autoclean;

use Carp;

has date => (
    is  => 'ro',
    isa => sub {
        ref $_[0] eq 'DateTime' or croak 'date, must be of type DateTime';
    }
);

has $_ => ( is => 'ro' ) foreach qw/check_number description/;

has amount => (
    is  => 'ro',
    isa => sub {
        ref $_[0] eq 'Math::Currency'
            or croak 'amount, must be of type Math::Currency';
    }
);

1;
