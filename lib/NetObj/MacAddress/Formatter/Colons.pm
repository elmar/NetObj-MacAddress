use strict;
use warnings FATAL => 'all';

package NetObj::MacAddress::Formatter::Colons;

sub format {
    my ($mac) = @_;
    return join(':', unpack('H2' x 6, $mac->binary()));
}

1;
