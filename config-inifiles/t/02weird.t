use Config::IniFiles;
print "1..$t\n";

$t=1;
$ini = new Config::IniFiles -file => "t/test.ini";
# print "Weird characters in section name . ";
$value = $ini->val('[w]eird characters', 'multiline');
if ($value eq "This\nis a multi-line\nvalue") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

$t++;
$ini->newval("test7|anything", "exists", "yes");
$value = $ini->val("test7|anything", "exists");
if ($value eq "yes") {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

BEGIN { $t=2 }
