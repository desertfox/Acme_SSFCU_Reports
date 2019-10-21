package Acme::SSFCU::Reports::Output::Streams::Print;

# ABSTRACT: This is the base class for other Driver modules
use Moo;
use namespace::autoclean;

has handle => ( is => 'ro' );

sub execute {
    my $self = shift;
    my $data = shift;

    my $fake_fh = $self->handle;

    print $fake_fh $data;

    return;
}

1;
