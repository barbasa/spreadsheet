use strict;
use warnings;

use Test::More;

use MF::Cell;

BEGIN { use_ok( 'MF::SpreadSheet' ); }

{
    my $sh = MF::SpreadSheet->new();

    my $expected_cells;
    foreach my $row ( 1 .. $MF::Types::MAX_ROW ) {
        foreach my $column ( 'A' .. $MF::Types::MAX_COLUMN ) {
            $expected_cells->{"$row$column"} = MF::Cell->new();
        }
    }

    is_deeply($sh->cells, $expected_cells, 'cells initialization');

}

done_testing();
