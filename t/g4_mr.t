#!/usr/bin/perl

use strict;
use warnings;
use diagnostics;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use Test::More tests => 4;


#
#  Use it.
#
use_ok( 'Maildir::Reader');

#
#  Require it.
#
require_ok( 'Maildir::Reader' );

#
#  Create it.
#
my $mi = Maildir::Reader->new();
isa_ok( $mi, "Maildir::Reader" );

#
#  OK done.
#
ok(1, "Test nop");


