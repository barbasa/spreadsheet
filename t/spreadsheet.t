#!perl
use strict;
use warnings;

use Test::More;
use Test::Exception;

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

subtest 'set/query cell' => sub {
    my $ss = MF::SpreadSheet->new();
    $ss->set_cell(1, 'A', 7);
    is($ss->query_cell(1, 'A'), 7, 'set/query cell value');
    is($ss->query_cell(2, 'A'), qq{}, 'query empty cell value');

    TODO: {
         local $TODO = 'Sanity check on input need to be implemented';
         throws_ok{ $ss->set_cell(1000, 'Z', 8) } qr/Invalid row or column/, 'invalid input values caught okay';
    }
};

done_testing();
