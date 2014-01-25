package MF::Formula::SUM;

use Moose::Role;

requires 'cells';

sub do {
    my ($self,) = @_;

    my $tot = 0;
    foreach my $cell ( @{ $self->cells } ) {
       $tot += $cell->query;
    }
    return $tot;
}

1;
