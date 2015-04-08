use strict;
use warnings FATAL => 'all';

package NetObj::MacAddress::Formatter::Dashes;

sub format {
    my ($mac) = @_;
    return uc(join('-', unpack('H2' x 6, $_[0]->binary())));
}

1;
