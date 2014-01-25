use strict;
use warnings;

use Test::More; 

BEGIN { use_ok( 'MF::Cell' ); }

{
    isa_ok(MF::Cell->new, 'MF::Cell');
}

{
    my $cell = MF::Cell->new;
    is( $cell->content, '', 'defaulted content');
}

{
    my $cell = MF::Cell->new(content => '4.5');
    is( $cell->content, '4.5', 'set content');
}

subtest 'clear content' => sub {
    my $cell = MF::Cell->new(content => '5.6');
    is( $cell->content, '5.6');
    $cell->_clear_content;
    is( $cell->content, '');
};


done_testing();
