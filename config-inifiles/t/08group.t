use Config::IniFiles;
# $Id: 08group.t,v 1.1 2000-11-28 11:31:02 grail Exp $

print "1..$t\n";

# Test 1
# Group members with spaces
$t=1;
$ini = new Config::IniFiles( -file => 't/test.ini' );

$members = join " ", $ini->GroupMembers("group");
if ($members eq "group member one group member two group member three")
{
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

BEGIN { $t = 1 }

