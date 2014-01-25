use strict;
use warnings;
package MF::Cell;

use Moose;
use namespace::autoclean;
use MooseX::Types::Moose qw/Int ArrayRef HashRef Str/;

use MF::Types;
use MF::Formula;

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

# Set cell value. Take care of setting internal for formula.
sub set {
    my ($self, $content) = @_;

    $self->content($content || qq{});    
    #XXX Formulae type hardcoded!! Change it!
    if ( $self->content =~ m{^=(?<type>SUM|MAX|MIN)                                 # Formula type
                            \(
                                (?<top_left_column>\w+)(?<top_left_row>\d+):        # Top left label
                                (?<bottom_right_column>\w+)(?<bottom_left_row>\d+)  # Bottom right label
                            \)$}ix 
       ) {
        $self->_formula({
            type            => $+{type},
            top_left        => "$+{top_left_column}:$+{top_left_row}",
            bottom_right    => "$+{bottom_right_column}:$+{bottom_left_row}",
        });
    }

}

# Query the content of a cell. If needed apply formula.
sub query {
    my ($self, $spreadsheet) = @_;

    if ($self->has_formula ) {
        my $cells = $spreadsheet->get_cells_in_range(
                        $self->_formula->{top_left},
                        $self->_formula->{bottom_right},
        );
        #XXX Cache this value instead of recalculate every time
        return MF::Formula->with_traits( $self->_formula->{type} )->new( cells => $cells )->do;
    }
    return $self->content;
}


__PACKAGE__->meta->make_immutable;

1;
