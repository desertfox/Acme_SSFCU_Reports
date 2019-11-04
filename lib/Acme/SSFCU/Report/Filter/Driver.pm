package Acme::SSFCU::Report::Filter::Driver;

# ABSTRACT: This is the base class for other Driver modules

use Carp;

sub calculate {
	croak "This method must be implemented " . caller(3);
}


1;