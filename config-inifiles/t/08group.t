use strict;
use Test;
use Config::IniFiles;
# $Id: 08group.t,v 1.3 2001-08-03 15:37:58 grail Exp $

BEGIN { plan tests => 1 }

my $ini = new Config::IniFiles( -file => 't/test.ini' );
my $members;

# Test 1
# Group members with spaces

$members = join " ", $ini->GroupMembers("group");
ok($members eq "group member one group member two group member three");

# Test 2
# Adding a new section - updating groups list

# Test 3
# Deleting a section - updating groups list
