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

BEGIN { $t=1 }
