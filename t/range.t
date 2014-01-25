#!perl
use strict;
use warnings;

use Test::More; 
use Test::Exception;

BEGIN { use_ok( 'MF::Range' ); }

subtest 'initialization' => sub {
    isa_ok(MF::Range->new(top_left => 'A:1', bottom_right => 'C:3'), 'MF::Range');

    throws_ok{ MF::Range->new, }
            qr/Attribute \((to|bottom)_(left|right)\) is required/,
            'invalid initialization';
};

done_testing();
