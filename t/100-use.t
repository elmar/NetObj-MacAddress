#!perl
use strict;
use warnings;
use 5.014;

BEGIN { chdir 't' if -d 't'; }
use lib '../lib';

use Test::More; END { done_testing; }

BEGIN { use_ok('NetObj::MacAddress'); }
