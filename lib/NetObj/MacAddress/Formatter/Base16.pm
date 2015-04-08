use strict;
use warnings FATAL => 'all';

package NetObj::MacAddress::Formatter::Base16;

sub format {
    my ($mac) = @_;
    return join('', unpack('H2' x 6, $_[0]->binary()));
}

1;
