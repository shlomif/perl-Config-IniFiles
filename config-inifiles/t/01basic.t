use Config::IniFiles;
print "1..$t\n";

# test 1
$t=1;
$ini = new Config::IniFiles -file => "t/test.ini";
print "not " unless $ini;
print "ok 1\n";

# test 2
$t++;
# print "Reading a value .................. ";
$value = $ini->val('test2', 'five') || '';
if ($value eq 'value5') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 3
$t++;
# print "Creating a new value ............. ";
$ini->newval('test2', 'seven', 'value7');
$ini->RewriteConfig;
$ini->ReadConfig;
$value='';
$value = $ini->val('test2', 'seven');
if ($value eq 'value7') {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

# test 4
$t++;
# print "Deleting a value ................. ";
$ini->delval('test2', 'seven');
$ini->RewriteConfig;
$ini->ReadConfig;
$value='';
$value = $ini->val('test2', 'seven');
if (! defined ($value)) {
	print "ok $t\n";
} else {
	print "not ok $t\n";
}

BEGIN { $t=4 }

