package Acme::SSFCU::Report::History::Iterator;

use Moo;
use namespace::autoclean;

use Carp;
use aliased 'Acme::SSFCU::Report::History::Transaction::Factory' =>
    'Transaction_Factory';

has _index   => ( is => 'rw', default => 0 );
has _history => (
    is  => 'rw',
    isa => sub {
        croak "Incorrect _history Type: " . ref $_[0]
            unless ref $_[0] eq 'Acme::SSFCU::Report::History';
    },
    handles => { "transactions" => "transactions" }
);

sub is_done {
    my $self = shift;

    return ( $self->_index >= $self->get_count() && $self->reset_index );
}

sub next {
    my $self = shift;

    return $self->{_index}++;
}

sub get_transaction {
    my $self = shift;

    return $self->transactions->[ $self->_index ];
}

sub reset_index {
    my $self = shift;

    $self->{_index} = 0;

    return 1;
}

sub add_transaction {
    my $self        = shift;
    my $transaction = shift;

    push( @{ $self->transactions }, $transaction );

    return;
}

sub add_source {
    my $self   = shift;
    my $source = shift;

    my $transactions
        = Transaction_Factory->build_transactions_from_ssfcu_csv_file(
        $source);

    $self->add_transaction($_) foreach ( @{$transactions} );

    return;
}

sub get_count {
    my $self = shift;

    return scalar @{ $self->transactions };
}

1;
