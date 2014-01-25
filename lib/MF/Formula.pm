package MF::Formula;

use Moose;
use MooseX::Types::Moose qw/ArrayRef/;

use MF::Types;

with 'MooseX::Traits';

has cells => (
    is          => 'ro',
    isa         => ArrayRef['Cell'],
    required    => 1,
);

has '+_trait_namespace' => ( default => 'MF::Formula' );

__PACKAGE__->meta->make_immutable;
