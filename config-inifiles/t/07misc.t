use Config::IniFiles;

print "1..$t\n";

# Test 1
# Multiple equals in a parameter - should split on the first
$t=1;
$ini = new Config::IniFiles( -file => 't/test.ini' );
$value = $ini->val('test7', 'criterion') || '';
if ($value eq 'price <= maximum')  {
     print "ok $t\n";
} else {
     print "not ok $t\n";
}     

BEGIN { $t = 1 }

