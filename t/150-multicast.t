#!perl
use strict;
use warnings FATAL => 'all';

BEGIN { chdir 't' if -d 't'; }
use lib '../lib';

use Test::More; END { done_testing; }

use NetObj::MacAddress;

# the least significant bit of the first byte of a MAC address
# indicates whether it is unicast (0) or multicast (1)

my @unicast_list = qw(
    000000000000
    feffffffffff
    00ffffffffff
);
for my $unicast (@unicast_list) {
    my $mac = NetObj::MacAddress->new($unicast);
    ok( not ($mac->is_multicast()), "$mac is unicast" );
}

my @multicast_list = qw(
    010000000000
    ff0000000000
    ffffffffffff
);
for my $multicast (@multicast_list) {
    my $mac = NetObj::MacAddress->new($multicast);
    ok( $mac->is_multicast(), "$mac is multicast" );
}
