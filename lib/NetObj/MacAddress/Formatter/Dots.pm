use strict;
use warnings FATAL => 'all';

# ABSTRACT: formatting MAC addresses in Cisco notation

package NetObj::MacAddress::Formatter::Dots;

sub format {
    my ($mac) = @_;
    return join('.', unpack('H4' x 3, $_[0]->binary()));
}

1;

__END__

=head1 SYNOPSIS

  use NetObj::MacAddress::Formatter::Dots;
    my $mac = NetObj::MacAddress->new('080020abcdef');
      $mac->to_string('dots'); # '0800.20ab.cdef'

=head1 DESCRIPTION

Helper module to format a MAC address as a string in hex dot delimited format.

=method format

Method to do the actual formatting. Used by C<NetObj::MacAddress>.
