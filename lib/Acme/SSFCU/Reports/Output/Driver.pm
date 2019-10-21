package Acme::SSFCU::Reports::Output::Driver;

use Carp;

sub execute {
	croak "This method must be implemented " . caller(3);
}

1;