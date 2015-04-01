use strict;
use warnings FATAL => 'all';
package NetObj::MacAddress;

# ABSTRACT: represent a MAC address

use Moo;
use Carp;

sub _to_binary {
    my ($macaddr) = @_;

    $macaddr =~ s{[-:\.]}{}xmsgi;
    return unless $macaddr =~ m{\A [\d a-f]{12} \Z}xmsi;

    return pack('H2' x 6, unpack('A2' x 6, $macaddr));
}

use namespace::clean;

sub is_valid {
    my ($macaddr) = @_;
    croak 'NetObj::MacAddress::is_valid is a class method only'
    if ref($macaddr) eq __PACKAGE__;

    return !! _to_binary($macaddr);
}

1;
