use strict;
use Test;
use Config::IniFiles;

BEGIN { plan tests => 2 }

my ($ini, $value);

$ini = new Config::IniFiles -file => "t/test.ini";
$ini->SetFileName("t/test02.ini");

# Test 1
# print "Weird characters in section name . ";
$value = $ini->val('[w]eird characters', 'multiline');
ok($value eq "This$/is a multi-line$/value");

# Test 2
$ini->newval("test7|anything", "exists", "yes");
$value = $ini->val("test7|anything", "exists");
ok($value eq "yes");


