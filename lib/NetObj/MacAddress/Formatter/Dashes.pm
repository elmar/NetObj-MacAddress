use strict;
use warnings FATAL => 'all';

# ABSTRACT: formatting MAC addresses with dash separated hex values

package NetObj::MacAddress::Formatter::Dashes;

sub format {
    my ($mac) = @_;
    return uc(join('-', unpack('H2' x 6, $_[0]->binary())));
}

1;

__END__

=head1 SYNOPSIS

  use NetObj::MacAddress::Formatter::Dashes;
  my $mac = NetObj::MacAddress->new('080020abcdef');
  $mac->to_string('dashes'); # '08-00-20-AB-CD-EF'

=head1 DESCRIPTION

Helper module to format a MAC address as a string in hex dash delimited format.

=method format

Method to do the actual formatting. Used by C<NetObj::MacAddress>.
