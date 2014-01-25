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

    my $invalid_value = 'invalid value';
    throws_ok{ $ss->set_cell(3, 'B', $invalid_value) }
            qr/Validation failed for 'CellValue' with value "$invalid_value"/,
            'invalid cell content caught okay';

    TODO: {
         local $TODO = 'Sanity check on input need to be implemented';
         throws_ok{ $ss->set_cell(1000, 'Z', 8) } qr/Invalid row or column/, 'invalid input values caught okay';
    }
};

subtest 'formula' => sub {

    my $ss = MF::SpreadSheet->new();

    lives_ok{ $ss->set_cell(1, 'C', '=SUM(A3:C5)'); } 'formula set fine';
    is($ss->cells->{"1C"}->has_formula, 1, 'formula field populated');
    TODO: {
         local $TODO = 'Test all field for formula are correctly populated';
        is_deeply($ss->cells->{"1C",}->_formula,{},); 
    }
    $ss->set_cell(3, 'A', 7);
    $ss->set_cell(5, 'C', 8);
    is($ss->query_cell(1, 'C'), 15, 'SUM correctly applied');
    
};

subtest 'range' => sub {
    my $ss = MF::SpreadSheet->new();
    my $cells = $ss->get_cells_in_range('A:1','B:2');
    is(@$cells, 4, 'count cells');
    foreach my $cell (@$cells) {
       isa_ok($cell, 'MF::Cell'); 
    }

    my $single_cell = $ss->get_cells_in_range('A:1','A:1');
    is(@$single_cell, 1, 'single cell');
    isa_ok($single_cell->[0], 'MF::Cell'); 
};

done_testing();
