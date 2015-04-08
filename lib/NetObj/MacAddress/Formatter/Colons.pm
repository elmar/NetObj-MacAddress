use strict;
use warnings FATAL => 'all';

# ABSTRACT: formatting MAC addresses with colon separated hex values

package NetObj::MacAddress::Formatter::Colons;

sub format {
    my ($mac) = @_;
    return join(':', unpack('H2' x 6, $mac->binary()));
}

1;
