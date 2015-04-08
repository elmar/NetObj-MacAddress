use strict;
use warnings FATAL => 'all';

package NetObj::MacAddress::Formatter::Dots;

sub format {
    my ($mac) = @_;
    return join('.', unpack('H4' x 3, $_[0]->binary()));
}

1;
