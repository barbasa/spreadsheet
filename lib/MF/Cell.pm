use strict;
use warnings;
package MF::Cell;

use Moose;
use namespace::autoclean;
use MF::Types;

has content => (
    isa         => 'CellValue',
    is          => 'rw',
    lazy        => 1,
    default     => '',
    clearer     => '_clear_content',
);

sub set {
    my ($self, $value) = @_;

    $self->content($value);
}

sub query {
    my ($self,) = @_;

    return $self->content;
}


__PACKAGE__->meta->make_immutable;

1;
