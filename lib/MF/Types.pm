package MF::Types;

use Moose::Util::TypeConstraints;
use MooseX::Types::Moose qw/Int ArrayRef HashRef Str/;

our $MAX_ROW     = 10; # XXX Load from confing file
our $MAX_COLUMN  = 'H';

class_type 'Cell', { class => 'MF::Cell' };

subtype    'EmptyCell' => as 'Str', where { $_ eq q{} };
subtype 'Formula' => as 'Str',
where {
    $_ =~ m{^=(SUM|MAX|MIN)\(\w+\d+:\w+\d+\)$}i;
},
message { "Invalid formula: $_" };

union      'CellValue' => [ qw{Num EmptyCell Formula} ];

subtype 'CellLabel' => as 'Str',
where {
    my ($col,$row) = $_ =~ /^(\w+):(\d+)$/;
    defined($col) && defined($row);
},
message { "Invalid cell label: ".( $_ || 'UNDEF') };

no Moose::Util::TypeConstraints;

1;
