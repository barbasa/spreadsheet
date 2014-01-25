use strict;
use warnings;
package MF::SpreadSheet;

use Moose;
use namespace::autoclean;
use MooseX::Types::Moose qw/Int ArrayRef HashRef Str/;

use MF::Types;
use MF::Cell;
use MF::Range;

has cells => (
    isa     => HashRef['Cell'],
    is      => 'rw',
    lazy    => 1,
    clearer => '_clear_cells',
    builder => '_build_cells',
    predicate => 'has_cells',
);

has max_row => (
    isa     => Int,
    is      => 'ro',
    lazy    => 1, 
    default => sub { $MF::Types::MAX_ROW  },
);

has max_column => (
    isa     => Str,
    is      => 'ro',
    lazy    => 1, 
    default => sub { $MF::Types::MAX_COLUMN  },
);

sub print {
    my ($self, ) = @_;

    # Column headers 
    print "\t"; print join("\t", ('A' .. $self->max_column ) ); print "\n";
    #XXX How do we extend this in case we wanna have more cells
    foreach my $row ( 1 .. $self->max_row ) {
        # Row headers
        print "$row)\t";
        foreach my $column ( "A" .. $self->max_column ) {
            #XXX delegate print of the content to Cell object
            print $self->cells->{"$row$column"}->content . "\t";
        }
        print "\n";
    }
    
}

#XXX When getting and setting parameter we need to check the coordinates
# are in the allowed range
sub set_cell {
    my ($self, $row, $column,$value) = @_;
    #XXX the cell object ($self->{"$row$column"})
    # need to be made accessible by a method
    $self->cells->{"$row$column"} ||= MF::Cell->new();
    $self->cells->{"$row$column"}->set($value);
}

sub query_cell {
    my ($self, $row, $column,) = @_;

    $self->cells->{"$row$column"} ||= MF::Cell->new();
    my $cell = $self->cells->{"$row$column"};
    return $cell->query($self);
}

sub get_range {
    my ($self, $top_left, $bottom_right,) = @_;

    $self->cells unless $self->has_cells;
    my $range = MF::Range->new( top_left => $top_left, bottom_right => $bottom_right,);
    return $range->get_cells($self);
}

sub _build_cells {
    my ($self, ) = @_;
    my $cells;
    foreach my $row ( 1 .. $self->max_row ) {
        foreach my $column ( 'A' .. $self->max_column ) {
            $cells->{"$row$column"} = MF::Cell->new();
        }
    }
    $self->cells( $cells );
}

#XXX pod

__PACKAGE__->meta->make_immutable;

1;
