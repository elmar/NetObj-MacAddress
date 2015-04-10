use strict;
use warnings FATAL => 'all';

# ABSTRACT: formatting MAC addresses in base16 hex format

package NetObj::MacAddress::Formatter::Base16;

sub format {
    my ($mac) = @_;
    return join('', unpack('H2' x 6, $_[0]->binary()));
}

1;

__END__

=head1 SYNOPSIS

  use NetObj::MacAddress::Formatter::Base16; # implicit for base16 format
  my $mac = NetObj::MacAddress->new('080020abcdef');
  $mac->to_string('base16'); # '080020abcdef'

=head1 DESCRIPTION

Helper module to format a MAC address as a string in hex base16 format.

=method format

Method to do the actual formatting. Used by C<NetObj::MacAddress>.
