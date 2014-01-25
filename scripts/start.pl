use strict;
use warnings;

use lib './lib';
use MF::SpreadSheet;

my $ss = MF::SpreadSheet->new();
$ss->print;

$ss->set_cell(1, 'C', '=SUM(A3:C5)');

$ss->set_cell(3, 'A', 7);
$ss->set_cell(5, 'C', 8);

$ss->print;

my $sum = $ss->query_cell(1, 'C');

print "\n\n*** C1 = Sum of range A3..C5 ... that is $sum\n";
