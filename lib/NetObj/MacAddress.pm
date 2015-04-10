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

use overload q(<=>) => sub {
    my ($x, $y) = @_;
    return $x->binary() cmp $y->binary()
};
use overload q(cmp) => sub {
    my ($x, $y) = @_;
    return "$x" cmp "$y"
};


# NOTE: vec(EXPR, OFFSET, BITS) treats EXPR as little endian on all platforms
# see: perldoc -f vec

sub is_unicast {
    my ($self) = @_;
    return not vec($self->binary(), 0, 1);
}

sub is_multicast {
    my ($self) = @_;
    return not $self->is_unicast();
}

sub is_global {
    my ($self) = @_;
    return not vec($self->binary(), 1, 1);
}

sub is_local {
    my ($self) = @_;
    return not $self->is_global();
}

1;

__END__

=head1 SYNOPSIS

  use NetObj::MacAddress

  # construct, supports various typical notations
  my $mac1 = NetObj::MacAddress->new('08:00:20:1e:bc:78');
  my $mac2 = NetObj::MacAddress->new('08-00-20-1E-BC-78');
  my $mac3 = NetObj::MacAddress->new('6c40.087c.5e90');

  # comparison, numerically
  $mac1 == $mac2;  # true
  $mac1 != $mac2;  # false
  $mac1 == $mac3;  # false
  $mac1 != $mac3;  # true

  # comparison, stringwise
  $mac1 eq $mac2;  # true
  $mac1 ne $mac2;  # false
  $mac1 eq $mac3;  # false
  $mac1 ne $mac3;  # true

  # reject invalid MAC addresses
  my $invalid_mac = NetObj::MacAddress->new('foo'); # throws exception

  # test for validity
  NetObj::MacAddress::is_valid('08:00:20:1e:bc:78'); # true
  NetObj::MacAddress::is_valid('foo');               # false

  # allow raw binary MAC addresses (any combination of 6 bytes)
  my $mac4 = NetObj::MacAddress->new('l@,foo');
  # represent as hex (base16)
  $mac4->to_string(); # '6c402c666f6f'
  # or as the raw binary
  $mac4->binary(); # 'l@,foo'

=head1 DESCRIPTION

NetObj::MacAddress represents MAC addresses. The constructor makes sure that
only valid MAC addresses can be instantiated.  Two MAC addresses compare equal
if they represent the same address independently of the notation used in the
constructor.

NetObj::MacAddress is implemented as a Moose style object class (using Moo).

=method is_valid

The class method C<NetObj::MacAddress::is_valid> tests for the validity of a MAC address represented by a string.  It does not throw an exception but returns false for an invalid and true for a valid MAC address.

=method new

The constructor expects exactly one argument either as a raw 6 byte value or a
string representation in a typically notation of hex characters.  It throws an
exception for invalid MAC addresses.

=method binary

The C<binary> method returns the raw 6 bytes of the MAC address.

=method to_string

The C<to_string> method returns the MAC address in hex notation (base16).  Optionally, if it is given the name of a formatter it will format the string in the corresponding style.  The default style is called C<'base16'>.

  my $mac = NetObj::MacAddress->new('0800201ebc78');

  $mac->to_string();         # '0800201ebc78'
  $mac->to_string('base16'); # '0800201ebc78'

  use NetObj::MacAddress::Formatter::Colons;
  $mac->to_string('colons'); # '08:00:20:1e:bc:78'

  use NetObj::MacAddress::Formatter::Dashes;
  $mac->to_string('dashes'); # '08-00-20-1E-BC-78'

  use NetObj::MacAddress::Formatter::Dots;
  $mac->to_string('dots'); # '0800.201e.bc78'

Some formatters are available by default (see examples above), others can be
added if needed by providing a module with a package name beginning with
C<NetObj::MacAddress::Formatter::> similarly to the existing ones.

=method is_multicast
=method is_unicast

The methods C<is_multicast> and C<is_unicast> indicate whether a MAC address is
multicast or unicast, respectively.

  my $unicast_mac   = NetObj::MacAddress->new('000001abcdef');
  my $multicast_mac = NetObj::MacAddress->new('010001abcdef');
  $unicast_mac->is_unicast();     # true
  $unicast_mac->is_multicast();   # false
  $multicast_mac->is_unicast();   # false
  $multicast_mac->is_multicast(); # true

=method is_global
=method is_local

The methods C<is_global> and C<is_local> indicate whether a MAC address is
globally or locally assigned, respectively.

  my $local_mac  = NetObj::MacAddress->new('000001abcdef');
  my $global_mac = NetObj::MacAddress->new('020001abcdef');
  $local_mac->is_local();   # true
  $local_mac->is_global();  # false
  $global_mac->is_local();  # false
  $global_mac->is_global(); # true

=for Pod::Coverage
BUILDARGS
