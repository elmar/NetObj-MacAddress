use strict;
use warnings FATAL => 'all';
use 5.014;
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

    return { binary => $mac->binary() } if ref($mac) eq __PACKAGE__;

    $mac = _to_binary($mac) unless length($mac) == 6;
    croak 'invalid MAC address' unless $mac;
    return { binary => $mac };
}

use NetObj::MacAddress::Formatter::Base16;
sub to_string {
    my ($self, $format) = @_;
    $format //= 'base16';
    $format = lc($format);

    state $formatter = {};

    if (not exists($formatter->{$format})) {
        my $pkg = ucfirst($format);
        my $sub = "NetObj::MacAddress::Formatter::${pkg}::format";
        if (defined(&$sub)) {
            $formatter->{$format} = \&$sub;
        }
        else {
            croak "no formatter for $format";
        }
    }
    return $formatter->{$format}($self);
}

use overload q("") => sub {shift->to_string};

use overload q(<=>) => sub { my ($x, $y) = @_; return "$x" cmp "$y" };
1;
