use strict;
use warnings;
package MF::Cell;

use Moose;
use namespace::autoclean;
use MooseX::Types::Moose qw/Int ArrayRef HashRef Str/;

use MF::Types;

has content => (
    isa         => 'CellValue',
    is          => 'rw',
    lazy        => 1,
    builder     => 'set',
    clearer     => '_clear_content',
    #XXX Add a trigger to clean the formula attribute if needed
);

has _formula => (
    isa         => HashRef, #XXX should create a Formula type
    is          => 'rw',
    predicate   => 'has_formula', 
);

sub set {
    my ($self, $content) = @_;

    $self->content($content || qq{});    
    #XXX could have better formatted the following regexp with x :/
    if ( $self->content =~ m{^=(?<type>SUM|MAX|MIN)\((?<top_left>\w+\d+):(?<bottom_right>\w+\d+)\)$}i ) {
        $self->_formula({
            type            => $+{type},
            top_left        => $+{top_left},
            bottom_right    => $+{bottom_right},
        });
    }

}

sub query {
    my ($self, $spreadsheet) = @_;

    if ($self->has_formula ) {
        my $range = MF::Range->new( top_left => $self->_formula->{top_left}, bottom_right => $self->_formula->{bottom_right}, );
    }
    return $self->content;
}


__PACKAGE__->meta->make_immutable;

1;
