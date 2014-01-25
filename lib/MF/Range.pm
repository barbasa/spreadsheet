use strict;
use warnings;
package MF::Range;

use Moose;
use namespace::autoclean;
use MooseX::Types::Moose qw/Int Str/;

use MF::Types;


has ['top_left', 'bottom_right'] => (
            is          => 'ro',
            isa         => 'CellLabel',
            required    => 1,
);

has ['_top_left_row', '_bottom_right_row'] => (
            is      => 'rw',
            isa     => Int, #XXX Create RowId type
);

has ['_top_left_column', '_bottom_right_column'] => (
            is => 'rw',
            isa => Str, #XXX Create column Id type
);

sub BUILD {
    my ($self) = @_;

    #XXX Need to check that the range values are correct: i.e.: top left values < bottom right
    my ($top_left_col, $top_left_row) = split /:/,$self->top_left; 
    $self->_top_left_row($top_left_row);
    $self->_top_left_column($top_left_col);

    my ($bottom_right_col, $bottom_right_row) = split /:/,$self->bottom_right;
    $self->_bottom_right_row($bottom_right_row);
    $self->_bottom_right_column($bottom_right_col);
}

# Retunr cells in a given range
sub get_cells {
    my ($self, $spreadsheet) = @_;

    my @cells;
    foreach my $row ( $self->_top_left_row .. $self->_bottom_right_row ) {
        foreach my $column ( $self->_top_left_column .. $self->_bottom_right_column ) {
            push @cells, $spreadsheet->cells->{"$row$column"};
        } 
    }

    return \@cells; 
}

__PACKAGE__->meta->make_immutable;

1;
