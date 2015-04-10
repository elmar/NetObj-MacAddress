use strict;
use warnings FATAL => 'all';

# ABSTRACT: formatting MAC addresses with colon separated hex values

package NetObj::MacAddress::Formatter::Colons;

sub format {
    my ($mac) = @_;
    return join(':', unpack('H2' x 6, $mac->binary()));
}

1;

__END__

=head1 SYNOPSIS

  use NetObj::MacAddress::Formatter::Colons;
  my $mac = NetObj::MacAddress->new('080020abcdef');
  $mac->to_string('colons'); # '08:00:20:ab:cd:ef'

=head1 DESCRIPTION

Helper module to format a MAC address as a string in hex colon delimeted
format.

=method format

Method to do the actual formatting. Used by C<NetObj::MacAddress>.
