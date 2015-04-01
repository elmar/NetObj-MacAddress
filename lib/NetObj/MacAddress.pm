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

has binary => (
    is => 'ro',
);

sub BUILDARGS {
    my ($class, $mac, @args) = @_;
    croak 'no MAC address given' unless defined($mac);
    croak 'too many arguments in constructor for ' . __PACKAGE__ if @args;

    $mac = _to_binary($mac) unless length($mac) == 6;
    croak 'invalid MAC address' unless $mac;
    return { binary => $mac };
}

1;
