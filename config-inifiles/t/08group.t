use strict;
use Test;
use Config::IniFiles;
# $Id: 08group.t,v 1.2 2000-12-16 11:48:21 grail Exp $

BEGIN { plan tests => 1 }

my $ini = new Config::IniFiles( -file => 't/test.ini' );
my $members;

# Test 1
# Group members with spaces

$members = join " ", $ini->GroupMembers("group");
ok($members eq "group member one group member two group member three");


