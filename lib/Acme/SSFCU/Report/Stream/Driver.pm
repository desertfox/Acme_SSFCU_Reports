package Acme::SSFCU::Report::Output::Stream::Driver;

# ABSTRACT: This is the base class for other Driver modules

use Carp;

sub execute {
	croak "This method must be implemented " . caller(3);
}

1;