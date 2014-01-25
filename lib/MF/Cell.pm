use strict;
use warnings;
package MF::Cell;

use Moose;
use namespace::autoclean;
use MF::Types;
#use MooseX::Types::Moose qw/Str/;

has content => (
    isa         => 'CellValue',
    is          => 'rw',
    lazy        => 1,
    default     => '',
    clearer     => '_clear_content',
);


__PACKAGE__->meta->make_immutable;

1;
