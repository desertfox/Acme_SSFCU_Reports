package Acme::SSFCU::Report::History::Iterator;

use Moo;
use namespace::autoclean;

has _index   => ( is => 'rw', default => 0 );
has _history => ( is => 'rw' );

sub is_done {
    my $self = shift;

    return (   $self->{_index} >= $self->{_history}->get_count()
            && $self->reset_index );
}

sub next {
    my $self = shift;

    return $self->{_index}++;
}

sub item {
    my $self = shift;

    return $self->{_history}->{transactions}[ $self->{_index} ];
}

sub reset_index {
    my $self = shift;
    $self->{_index} = 0;
    return 1;
}

1;
